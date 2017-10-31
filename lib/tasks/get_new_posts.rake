task :get_new_posts => :environment do |t, args|
  Community.where(screen_name: 'vichnet').all.each do |community|
    vk = VkontakteApi::Client.new Settings.vk.user_access_token
    step_size = 100
    step = 0
    posts = vk.wall.get(owner_id: -community.vk_id, count: step_size, offset: step*step_size, extended: 1)
    posts[:items].each do |post_hash|
      post = Post.where(vk_id: post_hash[:id]).where(community_id: community.id).first
      if post.nil?
        post = Post.create(
          vk_id: post_hash[:id],
          community_id: community.id,
          raw: post_hash.to_json,
        )
      end
    end
  end
end
