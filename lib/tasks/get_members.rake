task :get_members, [:vk_id] => :environment do |t, args|
  vk = VkontakteApi::Client.new
  Community.all.each do |community|
    group_id = community.vk_id
    rest = 1
    step = 0
    step_size = 1000
    all_members = []
    while rest > 0
      members = vk_lock { vk.groups.get_members(group_id: group_id, count: step_size, offset: step*step_size) }
      all_members += members[:items]
      if step == 0
        rest = members[:count] - step_size
      else
        rest -= step_size
      end
      step += 1
      sleep 0.5
    end
    prev_community_member = CommunityMemberHistory.where(community_id: community.id).order('created_at desc').first
    if prev_community_member.nil?
      diff = {added: [], removed: []}
    else
      prev_members = JSON::parse prev_community_member.members
      diff = {added: all_members - prev_members, removed: prev_members - all_members}
    end
    CommunityMemberHistory.create(
      community_id: community.id,
      members: all_members.to_json,
      members_count: all_members.count,
      diff: diff.to_json,
    )
  end
end