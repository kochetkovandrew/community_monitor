task :get_posts, [:screen_name] => :environment do |t, args|
  community = Community.find_by_screen_name args[:screen_name]
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  step_size = 100
  rest = 1
  step = 0
  all_posts = []
  while rest > 0
    posts = vk.wall.get(owner_id: -community.vk_id, count: step_size, offset: step*step_size, extended: 1)
    posts[:items].each do |post_hash|
      post = Post.create(
        vk_id: post_hash[:id],
        community_id: community.id,
        raw: post_hash.to_json,
      )
    end
    if step == 0
      rest = posts[:count] - step_size
    else
      rest -= step_size
    end
    step += 1
    sleep 0.5
  end
end