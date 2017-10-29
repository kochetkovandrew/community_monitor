task :get_posts, [:screen_name] => :environment do |t, args|
  community = Community.where(screen_name: args[:screen_name]).first
  if community.nil?
    member = Member.where(screen_name: args[:screen_name]).first
  end
  if community.nil? && member.nil?
    puts 'Couldn\'t find any community or person'
    exit 0
  end
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  step_size = 100
  rest = 1
  step = 0
  all_posts = []
  while rest > 0
    posts = vk.wall.get(owner_id: (community.nil? ? member.vk_id : -community.vk_id), count: step_size, offset: step*step_size, extended: 1)
    posts[:items].each do |post_hash|
      post = Post.create(
        vk_id: post_hash[:id],
        community_id: community.nil? ? nil : community.id,
        member_id: member.nil? ? nil : member.id,
        raw: post_hash.to_json,
      )
    end
    if step == 0
      rest = posts[:count] - step_size
    else
      rest -= step_size
    end
    step += 1
    sleep 0.35
  end
end
