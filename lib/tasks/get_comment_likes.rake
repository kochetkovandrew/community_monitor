task :get_comment_likes, [:screen_name] => :environment do |t, args|
  community = Community.find_by_screen_name args[:screen_name]
  posts = Post.where(community_id: community.id).where('not likes_handled').all
  comments = PostComment.
      joins('left join posts on posts.id = post_comments.post_id').
      where('posts.community_id = ?', community.id).
      where('post_comments.likes_count > 0').
      where('not post_comments.likes_handled').
      order('created_at asc').all
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  step_size = 1000
  comments.each_show_progress do |comment|
    begin
      rest = 1
      step = 0
      all_likes = []
      while rest > 0
        likes = vk_lock { vk.likes.get_list(type: 'comment', owner_id: -(community.vk_id), item_id: comment.vk_id, count: step_size, offset: step*step_size) }
        all_likes += likes[:items]
        if step == 0
          rest = likes[:count] - step_size
        else
          rest -= step_size
        end
        step += 1
        sleep 0.35
      end
      comment.likes = all_likes.to_json
      comment.likes_handled = true
      comment.save(touch: false)
    rescue VkontakteApi::Error
      puts e.message
      raise 'Something wend wrong'
    end
  end
end

