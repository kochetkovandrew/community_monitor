task move_friends: :environment do
  members = Member.all
  members.each_show_progress do |member|
    new_friends = []
    (member.raw_friends || []).each do |friend_hash|
      if friend_hash.kind_of?(Hash)
        existing = Member.find_by_vk_id friend_hash['id']
        if !existing.nil?
          friend = Member.new
          friend.set_from_hash(friend_hash)
          existing_hash = existing.comparable_hash
          new_hash = friend.comparable_hash
          if existing_hash != new_hash
            if (!existing.last_seen_at.nil?) && (friend.last_seen_at.nil? || (existing.last_seen_at > friend.last_seen_at))
              found_history = false
              MemberHistory.where(member_id: existing.id).all.each do |member_history|
                if member_history.comparable_hash == new_hash
                  found_history = true
                  break
                end
              end
              if !found_history
                member_history = MemberHistory.create(
                  member_id: existing.id,
                  first_name: friend.first_name,
                  last_name: friend.last_name,
                  raw: friend.raw,
                )
              end
            else
              found_history = false
              MemberHistory.where(member_id: existing.id).all.each do |member_history|
                if member_history.comparable_hash == new_hash
                  found_history = true
                  break
                end
              end
              if !found_history
                member_history = MemberHistory.create(
                  member_id: existing.id,
                  first_name: existing.first_name,
                  last_name: existing.last_name,
                  raw: existing.raw,
                )
              end
              existing.set_from_hash(friend_hash)
              existing.save
            end
          end
          new_friends.push friend_hash['id']
        else
          friend = Member.new
          friend.set_from_hash(friend_hash)
          friend.is_friend = true
          friend.save
          new_friends.push friend_hash['id']
        end
      else
        new_friends.push friend_hash
      end
    end
    member.raw_friends = new_friends
    member.save(touch: false)
  end
end