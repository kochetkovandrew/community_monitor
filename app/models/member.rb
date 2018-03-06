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
    #set_friends_from_vk(vk)
    #set_followers_from_vk(vk)
  end

  def friends_from_vk(vk = nil)
    vk ||= VkontakteApi::Client.new Settings.vk.user_access_token
    all_friends = []
    success = true
    step_size = 5000
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
    # if success
    #   self.raw_friends = all_friends
    # end
    all_friends
  end


  def followers_from_vk(vk = nil)
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
    # if success
    #   self.raw_followers = all_friends
    # end
    all_friends
  end

  def get_followers
    self.raw_followers || []
  end

  def get_friends
    self.raw_friends || []
  end

  def friends_in_communities
    if is_friend || new_record?
      friends = friends_from_vk
      followers = followers_from_vk
      friend_arr = friends + followers
      friend_ids = friend_arr.collect{|friend| friend[:id]}
    else
      friend_arr = get_friends + get_followers
      friend_ids = friend_arr.select{|elem| elem.kind_of?(Integer)}
    end
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
    if is_friend || new_record?
      friends_hash = Hash[friend_arr.collect{|fr| [fr[:id], fr]}]
    else
      friends_arr = Member.where(vk_id: friends_in_communities_arr.collect{|fica| fica[:friends]}.flatten.uniq).all
      friends_hash = Hash[friends_arr.collect{|fr| [fr.vk_id, fr]}]
    end
    return {friends: friends_hash, friends_in_communities: friends_in_communities_arr, member_of: member_of}
  end

  def comparable_hash
    {
      sex: self.sex,
      city_id: self.city_id,
      city_title: self.city_title || '',
      country_id: self.country_id,
      country_title: self.country_title || '',
      nickname: self.nickname || '',
      last_name: self.last_name || '',
      first_name: self.first_name || '',
    }
  end

  def set_from_hash(hash)
    hh = hash.with_indifferent_access
    self.raw ||= {}
    self.raw.merge!(hash)
    self.vk_id = hh[:id]
    self.sex = hh[:sex]
    self.last_seen_at = ((!hh[:last_seen].nil? && !hh[:last_seen][:time].nil?) ? Time.at(hh[:last_seen][:time]) : nil)
    self.last_seen_platform = (!hh[:last_seen].nil? ? hh[:last_seen][:platform] : nil)
    self.city_id = (!hh[:city].nil? ? hh[:city][:id] : nil)
    self.city_title = (!hh[:city].nil? ? hh[:city][:title] : nil)
    self.country_id = (!hh[:country].nil? ? hh[:country][:id] : nil)
    self.country_title = (!hh[:country].nil? ? hh[:country][:title] : nil)
    self.domain = hh[:domain]
    self.first_name = hh[:first_name]
    self.last_name = hh[:last_name]
    self.maiden_name = hh[:maiden_name]
    self.nickname = hh[:nickname]
    self.screen_name = hh[:screen_name] || hh[:domain] || ('id' + hh[:id].to_s)
  end

  def self.total_count
    q = "SELECT reltuples::bigint AS count FROM pg_class WHERE oid = 'members'::regclass"
    records_array = ActiveRecord::Base.connection.execute(q)
    records_array[0]['count'].to_i
  end

end
