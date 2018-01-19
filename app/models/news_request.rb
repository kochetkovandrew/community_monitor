class NewsRequest < ActiveRecord::Base

  def set_from_vk
    vk = VkontakteApi::Client.new Settings.vk.user_access_token
    raw_user = vk_lock { vk.users.get(user_ids: [self.vk_id], fields: [ :city, :country ])[0] }
    self.city_title = (!raw_user[:city].nil? ? raw_user[:city][:title] : nil)
    self.country_title = (!raw_user[:country].nil? ? raw_user[:country][:title] : nil)
    self.first_name = raw_user[:first_name]
    self.last_name = raw_user[:last_name]
    self.save
  end

end