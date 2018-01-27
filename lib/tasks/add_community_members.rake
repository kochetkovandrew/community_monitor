task add_community_members: :environment do
  all_member_ids = Member.select(:vk_id).all.collect{|member| member.vk_id}
  history_ids = CommunityMemberHistory.select('community_id, max(id) as max_id').group('community_id').collect{|cmh| cmh.max_id}
  @histories_hash = Hash[*(CommunityMemberHistory.where(id: history_ids).all.collect{|cmh| [cmh.community_id, cmh]}.flatten)]
  Community.where(monitor_members: true).all.each do |community|
    member_ids = (JSON::parse @histories_hash[community.id].try(:members) || '[]')
    member_ids.each do |member_id|
      if !all_member_ids.include?(member_id)
        member = Member.new(screen_name: member_id, manually_added: false)
        member.set_from_vk
        if member.screen_name.nil?
          member.screen_name = 'id' + member.vk_id.to_s
        end
        member.save
        all_member_ids.push member_id
      end
    end
  end
end