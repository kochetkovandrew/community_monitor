task :search_mummy => :environment do
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  people = []
  for year in 1979..1979
    for month in 1..12
      res = vk_lock { vk.users.search(country: 1, city: 119, sex: 1, birth_year: year, birth_month: month, fields: [:first_name, :last_name, :last_seen, :screen_name, :followers_count], count: 1000, sort: 1) }
      sleep 1
      people += res[:items]
    end
  end

  f = File.open(Rails.root.join('applog', 'mummy2.yaml'), 'w')
  fj = File.open(Rails.root.join('applog', 'mummy2.json'), 'w')
  # people.each do |person|
  #   member = Member.new(screen_name: item[:screen_name])
  #   member.set_from_vk
  #   member.set_followers_from_vk
  #   disp.push({member: JSON::parse(member.to_json), friends: JSON::parse(member.friends_in_communities.to_json)})
  # end
  f.puts people.to_yaml
  fj.puts people.to_json
end