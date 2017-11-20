task :get_new_posts => :environment do |t, args|
  Community.where(screen_name: 'detivich').all.each do |community|
    vk = VkontakteApi::Client.new Settings.vk.user_access_token
    step_size = 100
    step = 0
    total = 0
    exist = 0
    not_exist = 0
    for step in 1..10
      posts = vk_lock { vk.wall.get(owner_id: -community.vk_id, count: step_size, offset: step*step_size, extended: 1) }
      posts[:items].each do |post_hash|
        post = Post.where(vk_id: post_hash[:id]).where(community_id: community.id).first
        if post.nil?
          post = Post.new(
            vk_id: post_hash[:id],
            community_id: community.id,
            raw: post_hash.to_json,
            created_at: Time.at(post_hash[:date]),
          )
          not_exist += 1
        else
          exist += 1
        end
        total += 1
      end
    end
    puts community.screen_name + ' total: ' + total.to_s + ' exist: ' + exist.to_s + ' not exist: ' + not_exist.to_s
  end
end
