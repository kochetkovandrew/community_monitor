task :get_comments => :environment do
  posts = Post.where('community_id is not null').where('not handled').all
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  step_size = 100
  posts.each_show_progress do |post|
    begin
      rest = 1
      step = 0
      all_comments = []
      while rest > 0
        comments = vk.wall.get_comments(owner_id: -(post.community.vk_id), post_id: post.vk_id, count: step_size, offset: step*step_size, need_likes: 1)
        all_comments += comments[:items]
        if step == 0
          rest = comments[:count] - step_size
        else
          rest -= step_size
        end
        step += 1
        sleep 0.5
      end
      all_comments.each do |comment_hash|
        comment = PostComment.create(
          vk_id: comment_hash[:id],
          post_id: post.id,
          raw: comment_hash.to_json,
        )
      end
      post.handled = true
      post.save(touch: false)
    rescue VkontakteApi::Error
      puts e.message
      raise 'Something wend wrong'
    end
  end
end

