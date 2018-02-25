task get_topics: :environment do
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  Community.all.each do |community|
    step_size = 100
    rest = 1
    step = 0
    while rest > 0
      topics = vk_lock { vk.board.get_topics(group_id: community.vk_id, count: step_size, offset: step*step_size, extended: 0) }
      if step == 0
        rest = topics[:count] - step_size
      else
        rest -= step_size
      end
      step += 1
      new_found = false
      topics[:items].each do |topic_hash|
        topic = Topic.where(vk_id: topic_hash[:id], community_id: community.id).first
        if topic.nil?
          topic = Topic.create(
            vk_id: topic_hash[:id],
            community_id: community.id,
            raw: topic_hash,
            title: topic_hash[:title],
            created_by_vk_id: topic_hash[:created_by],
            created_at: Time.at(topic_hash[:created]),
            updated_at: Time.at(topic_hash[:updated]),
          )
          new_found = true
        else
          topic.update_attributes(updated_at: Time.at(topic_hash[:updated]))
        end
      end
      if !new_found
        break
      end
    end
  end

end