task :get_likes, [:screen_name] => :environment do |t, args|
  community = Community.find_by_screen_name args[:screen_name]
  posts = Post.where(community_id: community.id).where('not likes_handled').all
  vk = VkontakteApi::Client.new Rails.application.credentials.vk[:user_access_token]
  step_size = 1000
  posts.each_show_progress do |post|
    begin
      rest = 1
      step = 0
      all_likes = []
      while rest > 0
        likes = vk_lock { vk.likes.get_list(type: 'post', owner_id: -(post.community.vk_id), item_id: post.vk_id, count: step_size, offset: step*step_size) }
        all_likes += likes[:items]
        if step == 0
          rest = likes[:count] - step_size
        else
          rest -= step_size
        end
        step += 1
      end
      post.likes = all_likes.to_json
      post.likes_handled = true
      post.save(touch: false)
    rescue VkontakteApi::Error
      puts e.message
      raise 'Something went wrong'
    end
  end
end

