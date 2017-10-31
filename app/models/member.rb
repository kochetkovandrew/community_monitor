class Member < ActiveRecord::Base
  has_many :community_members
  has_many :communities, :through => :community_members
  has_many :posts

  validates :vk_id, uniqueness: true

  def set_from_vk
    vk = VkontakteApi::Client.new Settings.vk.user_access_token
    raw_user = vk.users.get(user_ids: [self.screen_name], fields: [ :photo_id, :verified, :sex, :bdate, :city, :country, :home_town, :has_photo, :photo_50, :photo_100, :photo_200_orig, :photo_200, :photo_400_orig, :photo_max, :photo_max_orig, :online, :domain, :has_mobile, :contacts, :site, :education, :universities, :schools, :status, :last_seen, :followers_count, :common_count, :occupation, :nickname, :relatives, :relation, :personal, :connections, :exports, :wall_comments, :activities, :interests, :music, :movies, :tv, :books, :games, :about, :quotes, :timezone, :screen_name, :maiden_name, :crop_photo, :friend_status, :career, :military ])[0]
    self.raw = raw_user.to_json
    self.vk_id = raw_user[:id]
    self.sex = raw_user[:sex]
    self.last_seen_at = ((!raw_user[:last_seen].nil? && raw_user[:last_seen][:time].nil?) ? Time.at(raw_user[:last_seen][:time]) : nil)
    self.last_seen_platform = (!raw_user[:last_seen].nil? ? raw_user[:last_seen][:platform] : nil)
    self.city_id = (!raw_user[:city].nil? ? raw_user[:city][:id] : nil)
    self.city_title = (!raw_user[:city].nil? ? raw_user[:city][:title] : nil)
    self.country_id = (!raw_user[:country].nil? ? raw_user[:country][:id] : nil)
    self.country_title = (!raw_user[:country].nil? ? raw_user[:country][:title] : nil)
    self.domain = raw_user[:domain]
    self.first_name = raw_user[:first_name]
    self.last_name = raw_user[:last_name]
    self.maiden_name = raw_user[:maiden_name]
    self.nickname = raw_user[:nickname]
    self.screen_name = raw_user[:screen_name]
    sleep 0.35
    step_size = 5000
    success = true
    all_friends = []
    begin
      rest = 1
      step = 0
      while rest > 0
        friends = vk.friends.get(user_id: self.vk_id, fields: [:nickname, :domain, :sex, :bdate, :city, :country, :timezone, :photo_50, :photo_100, :photo_200_orig, :has_mobile, :contacts, :education, :online, :relation, :last_seen, :status, :universities], count: step_size, offset: step*step_size)
        all_friends += friends[:items]
        if step == 0
          rest = friends[:count] - step_size
        else
          rest -= step_size
        end
        step += 1
        sleep 0.35
      end
    rescue
      success = false
    end
    if success
      self.raw_friends = all_friends.to_json
    end
  end

end
