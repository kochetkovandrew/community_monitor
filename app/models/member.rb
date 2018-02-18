class Member < ActiveRecord::Base
  has_many :community_members
  has_many :communities, :through => :community_members
  has_many :posts
  has_many :post_comments, primary_key: :vk_id, foreign_key: :user_vk_id

  validates :vk_id, uniqueness: true

  def set_from_vk
    vk = VkontakteApi::Client.new Settings.vk.user_access_token
    raw_user = vk_lock { vk.users.get(user_ids: [self.screen_name], fields: [ :photo_id, :verified, :sex, :bdate, :city, :country, :home_town, :has_photo, :photo_50, :photo_100, :photo_200_orig, :photo_200, :photo_400_orig, :photo_max, :photo_max_orig, :online, :domain, :has_mobile, :contacts, :site, :education, :universities, :schools, :status, :last_seen, :followers_count, :common_count, :occupation, :nickname, :relatives, :relation, :personal, :connections, :exports, :wall_comments, :activities, :interests, :music, :movies, :tv, :books, :games, :about, :quotes, :timezone, :screen_name, :maiden_name, :crop_photo, :friend_status, :career, :military ])[0] }
    self.raw = raw_user.to_json
    self.vk_id = raw_user[:id]
    self.sex = raw_user[:sex]
    self.last_seen_at = ((!raw_user[:last_seen].nil? && !raw_user[:last_seen][:time].nil?) ? Time.at(raw_user[:last_seen][:time]) : nil)
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
    step_size = 5000
    success = true
    all_friends = []
    begin
      rest = 1
      step = 0
      while rest > 0
        friends = vk_lock { vk.friends.get(user_id: self.vk_id, fields: [:nickname, :domain, :sex, :bdate, :city, :country, :timezone, :photo_50, :photo_100, :photo_200_orig, :has_mobile, :contacts, :education, :online, :relation, :last_seen, :status, :universities], count: step_size, offset: step*step_size) }
        all_friends += friends[:items]
        if step == 0
          rest = friends[:count] - step_size
        else
          rest -= step_size
        end
        step += 1
      end
    rescue
      success = false
    end
    if success
      self.raw_friends = all_friends.to_json
    end
    set_followers_from_vk(vk)
  end

  def set_followers_from_vk(vk = nil)
    vk ||= VkontakteApi::Client.new Settings.vk.user_access_token
    all_friends = []
    success = true
    begin
      rest = 1
      step = 0
      step_size = 1000
      while rest > 0
        friends = vk_lock { vk.users.get_followers(user_id: self.vk_id, fields: [:nickname, :domain, :sex, :bdate, :city, :country, :timezone, :photo_50, :photo_100, :photo_200_orig, :has_mobile, :contacts, :education, :online, :relation, :last_seen, :status, :universities], count: step_size, offset: step*step_size) }
        all_friends += friends[:items]
        if step == 0
          rest = friends[:count] - step_size
        else
          rest -= step_size
        end
        step += 1
      end
    rescue
     success = false
    end
    if success
      self.raw_followers = all_friends.to_json
    end
  end

  def get_followers
    if !self.raw_followers.nil? && (self.raw_followers != '')
      JSON::parse self.raw_followers
    else
      []
    end
  end

  def get_friends
    if !self.raw_friends.nil? && (self.raw_friends != '')
      JSON::parse self.raw_friends
    else
      []
    end
  end

  def friends_in_communities
    friend_arr = get_friends + get_followers
    friend_ids = friend_arr.collect{|friend| friend['id']}
    friend_hash = friend_arr.collect{|friend| [friend['id'], friend]}.to_h
    friends_in_communities_arr = []
    member_of = []
    Community.all.each do |community|
      cmh = community.community_member_histories.order('created_at desc').first
      if (!cmh.nil?)
        community_members = JSON::parse cmh.members
        intersection = (community_members & friend_ids)
        if !intersection.empty?
          friends_in_communities_arr.push({community: community, friends: intersection})
        end
        if self.vk_id.in?(community_members)
          member_of.push community
        end
      end
    end
    return {friend_hash: friend_hash, friends_in_communities: friends_in_communities_arr, member_of: member_of}
  end

end
