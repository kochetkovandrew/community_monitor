task check_last_seen: :environment do
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  all_members = Member.all
  while !(members = all_members.shift(1000)).empty?
    vk_ids = members.collect {|member| member.vk_id}.compact
    arr = members.collect {|member| [member.vk_id, member]}
    vk_to_member_map = Hash[arr]
    raw_users = vk_lock { vk.users.get(user_ids: vk_ids, fields: [:last_seen ]) }
    raw_users.each do |raw_user|
      if (!raw_user[:last_seen].nil? && !raw_user[:last_seen][:time].nil?)
        member = vk_to_member_map[raw_user[:id]]
        MemberLastSeen.create(
          last_seen_at: Time.at(raw_user[:last_seen][:time]),
          last_seen_platform: raw_user[:last_seen][:platform],
          member_id: member.id,
        )
        member.last_seen_at = Time.at(raw_user[:last_seen][:time])
        member.last_seen_platform = raw_user[:last_seen][:platform]
        member.save
      end
    end
  end
end