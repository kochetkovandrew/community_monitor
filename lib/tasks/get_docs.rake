task :get_docs => :environment do
  uid = 246924206
  did = File.read(Rails.root.join('applog', 'medichi_nummer.txt')).to_i
  p uid.to_s + '_' + did.to_s
  arr = []
  for i in 0..0
    arr.push(uid.to_s + '_' + did.to_s)
    did += 1
  end
  # p arr
  vk = VkontakteApi::Client.new Rails.application.credentials.vk[:user_access_token]
  res = vk.docs.getById(docs: arr.join(','))
  p res
  # res = vk.users.search(country: 1, city: 75, age_from: 30, sex: 1, q: 'Мария', fields: [:first_name, :last_name, :last_seen, :screen_name], count: 1000, sort: 1)
  # sleep 0.35
  # disp = []
  # f = File.open(Rails.root.join('applog', 'medichi.yaml'), 'w')
  # fj = File.open(Rails.root.join('applog', 'medichi.json'), 'w')
  # res[:items].each do |item|
  #   member = Member.new(screen_name: item[:screen_name])
  #   member.set_from_vk
  #   disp.push({member: member, friends: member.friends_in_communities})
  # end
  # f.puts disp.to_yaml
  # fj.puts disp.to_json
end