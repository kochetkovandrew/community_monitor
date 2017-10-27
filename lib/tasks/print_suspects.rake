task :print_suspects, [:screen_name] => :environment do |t, args|
  community = Community.find_by_screen_name args[:screen_name]
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  puts community.screen_name
  puts ''
  added = []
  i = 0
  prev_time = Time.now()
  community.community_member_histories.order('created_at asc').all.each do |history|
    if i == 1
      prev_time = history.created_at
      continue
    end
    diff = JSON::parse history.diff
    diff['added'].each do |vk_id|
      added.push({vk_id: vk_id, prev_time: prev_time, follow_time: history.created_at})
    end
    prev_time = history.created_at
  end
  vk_ids = added.collect{|user| user[:vk_id]}
  users = vk.users.get(user_ids: vk_ids, fields: [:first_name, :last_name, :last_seen], count: 1000)
  # p users
  users_hash = Hash[users.collect{|user| [user[:id], user]}]
  #p users_hash
  suspects = []
  wentwrong = []
  added.each do |added_item|
    user = users_hash[added_item[:vk_id]]
    if (!user.nil?)
      if !user[:last_seen].nil?
        last_seen = Time.at user[:last_seen][:time]
      else
        last_seen = nil
      end
      if last_seen.nil? || last_seen < added_item[:prev_time]
        suspects.push({
                        vk_id: added_item[:vk_id],
                        first_name: user[:first_name],
                        last_name: user[:last_name],
                        prev_check_time: added_item[:prev_time].strftime("%Y-%m-%d %H:%M:%S"),
                        check_time: added_item[:follow_time].strftime("%Y-%m-%d %H:%M:%S"),
                        last_seen: (last_seen.nil? ? '' : last_seen.strftime("%Y-%m-%d %H:%M:%S")),
                      })
      else
      end
    end
  end
  puts suspects.to_yaml
end