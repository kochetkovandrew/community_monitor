task :search => :environment do
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  res = vk.users.search(school: 7862, sex: 1, fields: [:first_name, :last_name, :last_seen], count: 1000, sort: 1)
  sep = Time.new(2017,9,1)
  all_items = []
  res[:items].each do |item|
    tt=Time.at(item[:last_seen][:time])
    if tt<sep
      all_items.push({time: tt, item: item})
    end
  end
  all_items.sort!{|a,b| b[:time]<=>a[:time]}
  puts all_items.to_yaml
end