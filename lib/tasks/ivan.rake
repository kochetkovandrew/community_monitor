task ivan: :environment do
  vk = VkontakteApi::Client.new Rails.application.credentials.vk[:user_access_token]
  ids = [241347183, 280997434, 51928437, 160263363]
  times = [[], [], [], []]
  raw_users = vk_lock { vk.users.get(user_ids: ids, fields: [:last_seen ]) }
  raw_users.each do |raw_user|
    times[ids.index(raw_user[:id])].push ((!raw_user[:last_seen].nil? && !raw_user[:last_seen][:time].nil?) ? Time.at(raw_user[:last_seen][:time]) : nil)
    platform_id = (!raw_user[:last_seen].nil? ? raw_user[:last_seen][:platform] : nil)
    platform = case platform_id
      when 1 then 'Mobile'
      when 2 then 'iPhone'
      when 3 then 'iPad'
      when 4 then 'Android'
      when 5 then 'WinPhone'
      when 6 then 'Win10'
      when 7 then 'Web'
      when 8 then 'Vk Mobile'
      else platform_id.to_s
    end
    # times[ids.index(raw_user[:id])].push (!raw_user[:last_seen].nil? ? raw_user[:last_seen][:platform] : nil)
    times[ids.index(raw_user[:id])].push platform
  end
  f = File.open(Rails.root.join('applog', 'krysyuk.csv'), 'a')
  str = '"' + Time.now.to_s + '","' + times[0][0].to_s + '","' + times[0][1].to_s +
    '","' + times[1][0].to_s + '","' + times[1][1].to_s +
    '","' + times[2][0].to_s + '","' + times[2][1].to_s +
    '","' + times[3][0].to_s + '","' + times[3][1].to_s + '"'
  f.puts str
  f.close
end