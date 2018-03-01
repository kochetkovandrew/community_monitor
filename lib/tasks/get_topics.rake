task get_topics: :environment do
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  Community.all.each do |community|
    community.get_topics
  end

end