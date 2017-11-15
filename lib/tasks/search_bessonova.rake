task :search_bessonova => :environment do
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  res = vk.users.search(country: 1, city: 99, age_from: 40, age_to: 41, sex: 1, q: 'Алла', fields: [:first_name, :last_name, :last_seen, :screen_name], count: 1000, sort: 1)
  sleep 0.35
  disp = []
  f = File.open(Rails.root.join('applog', 'bessoniha.yaml'), 'w')
  fj = File.open(Rails.root.join('applog', 'bessoniha.json'), 'w')
  res[:items].each do |item|
    member = Member.new(screen_name: item[:screen_name])
    member.set_from_vk
    member.set_followers_from_vk
    disp.push({member: JSON::parse(member.to_json), friends: JSON::parse(member.friends_in_communities.to_json)})
  end
  f.puts disp.to_yaml
  fj.puts disp.to_json
end