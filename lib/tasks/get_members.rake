task :get_members, [:vk_id] => :environment do |t, args|
  vk = VkontakteApi::Client.new
  Community.all.each do |community|
    group_id = community.vk_id
    rest = 1
    step = 0
    step_size = 1000
    all_members = []
    while rest > 0
      members = vk.groups.get_members(group_id: group_id, count: step_size, offset: step*step_size)
      all_members += members[:items]
      if step == 0
        rest = members[:count] - step_size
      else
        rest -= step_size
      end
      step += 1
      sleep 12
    end
    CommunityMemberHistory.create(
      community_id: community.id,
      members: all_members.to_json,
    )
  end
end