task get_topics: :environment do
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  topics = vk.board.get_topics(group_id: 69659144, count: 2, offset: 0, extended: 1)
  p topics

end