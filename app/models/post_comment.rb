class PostComment < ActiveRecord::Base
  belongs_to :post
  belongs_to :topic

  def get_likes(force = false, vk_client = nil)
    vk = (vk_client || VkontakteApi::Client.new(Settings.vk.user_access_token))
    step_size = 1000
    if raw['likes']['count'] > 0
      if likes.nil? || (likes.count < raw['likes']['count']) || force
        begin
          rest = 1
          step = 0
          all_likes = []
          while rest > 0
            owner_id = (post.community_id.nil? ? post.member.vk_id : -post.commuinity.vk_id)
            likes_chunk = vk_lock { vk.likes.get_list(type: 'comment', owner_id: owner_id, item_id: vk_id, count: step_size, offset: step*step_size) }
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
          raise 'Get comment likes: something went wrong'
        end
      end
    end
  end

end
