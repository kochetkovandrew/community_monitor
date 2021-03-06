class Topic < ActiveRecord::Base
  belongs_to :community
  has_many :post_comments

  def get_comments(vk_client = nil, force = false)
    vk = (vk_client || VkontakteApi::Client.new(Rails.application.credentials.vk[:user_access_token]))
    step_size = 100
    begin
      rest = 1
      step = 0
      while rest > 0
        new_found = false
        comments_chunk = vk_lock { vk.board.get_comments(group_id: community.vk_id, topic_id: vk_id, count: step_size, offset: step*step_size, need_likes: 1, sort: (handled ? 'desc' : 'asc')) }
        if step == 0
          rest = comments_chunk[:count] - step_size
        else
          rest -= step_size
        end
        step += 1
        items = comments_chunk[:items]
        item_ids = items.collect{|item| item[:id]}
        existing_ids = PostComment.where(vk_id: item_ids).where(topic_id: id).select([:vk_id]).all.collect {|comment| comment.vk_id}
        comments_chunk[:items].each do |comment_hash|
          if !(comment_hash[:id].in?(existing_ids))
            comment = PostComment.create(
              vk_id: comment_hash[:id],
              topic_id: id,
              raw: comment_hash,
              user_vk_id: comment_hash[:from_id],
              created_at: Time.at(comment_hash[:date]),
              likes_count: comment_hash[:likes][:count],
            )
            new_found = true
          end
        end
        if !new_found
          break
        end
      end
      self.handled = true
      self.save(touch: false)
    rescue VkontakteApi::Error => e
      puts e.message
      raise 'Something went wrong'
    end
  end

end
