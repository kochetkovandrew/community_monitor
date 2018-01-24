task migrate_last_seen: :environment do
  Member.all.each do |member|
    if !member.last_seen_at.nil?
      mls = MemberLastSeen.new(
        last_seen_at: member.last_seen_at,
        last_seen_platform: member.last_seen_platform,
        member_id: member.id,
      )
      mls.created_at = member.created_at
      mls.save(touch: false)
    end
  end
end