class Post < ActiveRecord::Base

  belongs_to :community
  belongs_to :member
  has_many :post_comments

  def get_likes(force = false, vk_client = nil)
    vk = (vk_client || VkontakteApi::Client.new(Settings.vk.user_access_token))
    owner_id = (community_id.nil? ? member.vk_id : -commuinity.vk_id)
    step_size = 1000
    if (raw['likes']['count'] > 0) || force
      if likes.nil? || (likes.count != raw['likes']['count']) || force
        begin
          rest = 1
          step = 0
          all_likes = []
          while rest > 0
            likes_chunk = vk_lock { vk.likes.get_list(type: 'post', owner_id: owner_id, item_id: vk_id, count: step_size, offset: step*step_size) }
            all_likes += likes_chunk[:items]
            if step == 0
              rest = likes_chunk[:count] - step_size
            else
              rest -= step_size
            end
            step += 1
          end
          self.likes = ((likes || []) + all_likes).uniq
          self.likes_handled = true
          self.save(touch: false)
        rescue VkontakteApi::Error => e
          puts e.message
          raise 'Get post likes: something went wrong'
        end
      end
    end
  end

  def get_comments(force = false, recurrent_force = false, vk_client = nil)
    vk = (vk_client || VkontakteApi::Client.new(Settings.vk.user_access_token))
    step_size = 100
    if (raw['comments']['count'] > 0) || force
      if (post_comments.count < raw['comments']['count']) || force
        begin
          rest = 1
          step = 0
          while rest > 0
            new_found = false
            comments_chunk = vk_lock { vk.wall.get_comments(owner_id: -(community.vk_id), post_id: vk_id, count: step_size, offset: step*step_size, need_likes: 1, sort: 'desc') }
            if step == 0
              rest = comments_chunk[:count] - step_size
            else
              rest -= step_size
            end
            step += 1
            items = comments_chunk[:items]
            item_ids = items.collect{|item| item[:id]}
            existing_comments = PostComment.where(vk_id: item_ids).where(post_id: id).all
            existing_ids = existing_comments.collect {|comment| comment.vk_id}
            existing_comments_hash = Hash[existing_comments.collect{|comment| [comment.vk_id, comment]}]
            items.each do |comment_hash|
              if !(comment_hash[:id].in?(existing_ids))
                comment = PostComment.create(
                  vk_id: comment_hash[:id],
                  post_id: id,
                  raw: comment_hash,
                  user_vk_id: comment_hash[:from_id],
                  created_at: Time.at(comment_hash[:date]),
                  likes_count: comment_hash[:likes][:count],
                )
                comment.get_likes(false, vk)
                new_found = true
              elsif existing_comments_hash[comment_hash[:id]].raw['likes']['count'] < comment_hash[:likes][:count]
                comment = existing_comments_hash[comment_hash[:id]]
                comment.raw['likes']['count'] = comment_hash[:likes][:count]
                comment.likes_count = comment_hash[:likes][:count]
                comment.save(touch: false)
                comment.get_likes(recurrent_force, vk)
              end
            end
            if !new_found && !force
              break
            end
          end
          self.handled = true
          self.save(touch: false)
        rescue VkontakteApi::Error => e
          puts e.message
          raise 'Get post comments: something went wrong'
        end
      end
    end
  end

  def self.new_or_create_from_wall(wall_item, source)
    post = Post.where(source).where(relative_id: wall_item[:id]).first
    copy_history = []
    if !wall_item[:copy_history].nil?
      wall_item[:copy_history].each do |history_item|
        copy_history.push({
                            from_id: history_item[:from_id].abs,
                            from_community: (history_item[:from_id] < 0),
                            published_at: Time.at(history_item[:date]).to_datetime,
                            text: history_item[:text]
                          })
      end
    end
    if post.nil?
      post = Post.new(
        body: wall_item[:text],
        copy_history: copy_history.to_json,
        from_id: wall_item[:from_id],
        published_at: Time.at(wall_item[:date]).to_datetime,
        relative_id: wall_item[:id],
      )
    end
    if !wall_item[:attachments].nil?
      puts wall_item[:attachments].to_yaml
    end
    post
  end

end
