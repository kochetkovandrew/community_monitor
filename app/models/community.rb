class Community < ActiveRecord::Base
  validates_numericality_of :vk_id, allow_blank: false
  # before_validation :set_vk_data
  attr_accessor :posts_count
  has_many :community_members
  has_many :community_member_histories
  has_many :members, :through => :community_members
  has_many :posts
  has_many :topics
  has_many :community_histories

  def get_from_vk
    vk = VkontakteApi::Client.new Rails.application.credentials.vk[:user_access_token]
    raw_group = vk_lock {
      vk.groups.get_by_id(
        group_id: self.screen_name,
        fields: [:id, :name, :screen_name, :photo_50, :photo_100, :photo_200, :city, :country, :contacts, :description]
      )
    }[0]
  end

  def set_from_vk(raw_hash = nil)
    raw_group = raw_hash || get_from_vk
    self.raw = raw_group
    self.vk_id = raw_group[:id]
    self.name = raw_group[:name]
    self.screen_name = raw_group[:screen_name] || ('club' + vk_id.to_s)
  end


  def set_vk_data
    self.vk_id = nil
    vk = VkontakteApi::Client.new (self.access_token || Rails.application.credentials.vk[:user_access_token])
    groups = vk_lock {
      vk.groups.get_by_id(
        group_id: self.screen_name,
        fields: [:id, :name, :screen_name, :photo_50, :photo_100, :photo_200, :city, :country, :contacts, :description]
      )
    }
    self.vk_id = groups[0][:id]
    self.name = groups[0][:name]
  rescue
  end

  def set_from_hash(hash)
    hh = hash.with_indifferent_access
    self.raw ||= {}
    self.raw.merge!(hash)
    self.vk_id = hh[:id]
    self.screen_name = hh[:screen_name] || ('club' + hh[:id].to_s)
    self.name = hh[:name]
  end

  def self.get_from_vk(vk_ids, settings = {})
    l_settings = {update_existing: false}.merge(settings)
    res = []
    preexisting_communities = []
    if !l_settings[:update_existing]
      preexisting_communities = Community.where(vk_id: vk_ids).all
      vk_ids -= preexisting_communities.collect{|community| community.vk_id}
    end
    vk = VkontakteApi::Client.new Rails.application.credentials.vk[:user_access_token]
    while !(vk_ids_slice = vk_ids.shift(500)).empty?
      if l_settings[:update_existing]
        existing_groups = Hash[Community.where(vk_id: vk_ids_slice).all.collect{|community| [community.vk_id, community]}]
      else
        existing_groups = {}
      end
      raw_groups = vk_lock { vk.groups.get_by_id(group_ids: vk_ids_slice, fields: [:id, :name, :screen_name, :photo_50, :photo_100, :photo_200, :city, :country, :contacts, :description]) }
      raw_groups.each do |raw_group|
        new_group = Community.new
        new_group.set_from_hash(raw_group)
        if existing_groups[raw_group[:id]].nil?
          new_group.save
          res.push new_group
        else
          existing_group = existing_groups[raw_group[:id]]
          existing_hash = existing_group.comparable_hash
          new_hash = new_group.comparable_hash
          Rails.logger.debug existing_hash
          Rails.logger.debug new_hash
          if existing_hash != new_hash
            community_history = CommunityHistory.create(
              community_id: existing_group.id,
              raw: existing_group.raw,
            )
            existing_group.set_from_hash(raw_group)
            existing_group.save
          end
          res.push existing_group
        end
      end
    end
    res + preexisting_communities
  end

  def update_history(new_hash)
    friend = Community.new
    friend.set_from_hash(new_hash)
    existing_hash = comparable_hash
    new_c_hash = friend.comparable_hash
    if existing_hash != new_c_hash
      found_history = false
      community_histories.each do |community_history|
        if community_history.comparable_hash == new_c_hash
          found_history = true
          break
        end
      end
      if !found_history
        community_history = CommunityHistory.create(
          community_id: id,
          raw: friend.raw,
        )
      end
    end
  end

  def comparable_hash
    {
      screen_name: self.screen_name,
      name: self.name,
      photo_200: (self.raw || {})['photo_200'],
    }
  end

  def get_wall(force = false)
    vk = VkontakteApi::Client.new (self.access_token || Rails.application.credentials.vk[:user_access_token])
    step_size = 100
    begin
      rest = 1
      step = 0
      while rest > 0
        new_found = false
        posts_chunk = vk_lock { vk.wall.get(owner_id: -vk_id, filter: 'all', count: step_size, offset: step*step_size, extended: 1) }
        if step == 0
          rest = posts_chunk[:count] - step_size
        else
          rest -= step_size
        end
        step += 1
        items = posts_chunk[:items]
        item_ids = items.collect{|item| item[:id]}
        existing_posts = Post.
          where('posts.vk_id': item_ids).
          where('posts.community_id': id).
          joins('left join post_comments on post_comments.post_id = posts.id').
          select('posts.*, count(post_comments.*) as post_comments_count').
          group('posts.id').all
        existing_ids = existing_posts.collect {|post| post.vk_id}
        existing_posts_hash = Hash[existing_posts.collect{|post| [post.vk_id, post]}]
        items.each do |post_hash|
          if !(post_hash[:id].in?(existing_ids))
            post = Post.create(
              vk_id: post_hash[:id],
              community_id: id,
              member_id: nil,
              raw: post_hash,
              created_at: Time.at(post_hash[:date]),
            )
            post.get_likes(false, vk)
            post.get_comments(false, false, vk)
            new_found = true
          else
            post = existing_posts_hash[post_hash[:id]]
            if post.raw['likes']['count'] < post_hash[:likes][:count]
              post = existing_posts_hash[post_hash[:id]]
              post.raw['likes']['count'] = post_hash[:likes][:count]
              post.save(touch: false)
              post.get_likes(force, vk)
            end
            if post.post_comments_count < post_hash[:comments][:count]
              post.raw['comments']['count'] = post_hash[:comments][:count]
              post.save(touch: false)
              post.get_comments(force, false, vk)
            end
          end
        end
        if !new_found && !force
          break
        end
      end
    rescue VkontakteApi::Error => e
      puts e.message
      raise 'Something went wrong'
    end
  end

  def get_topics(force = false)
    vk = VkontakteApi::Client.new (self.access_token || Rails.application.credentials.vk[:user_access_token])
    step_size = 100
    rest = 1
    step = 0
    while rest > 0
      topics = vk_lock { vk.board.get_topics(group_id: vk_id, count: step_size, offset: step*step_size, extended: 0) }
      if step == 0
        rest = topics[:count] - step_size
      else
        rest -= step_size
      end
      step += 1
      new_found = false
      topics[:items].each do |topic_hash|
        topic = Topic.where(vk_id: topic_hash[:id], community_id: id).first
        if topic.nil?
          topic = Topic.new(
            vk_id: topic_hash[:id],
            community_id: id,
            raw: topic_hash,
            title: topic_hash[:title],
            created_by_vk_id: topic_hash[:created_by],
          )
          topic.created_at = Time.at(topic_hash[:created])
          topic.updated_at = Time.at(topic_hash[:updated])
          topic.save(touch: false)
          topic.get_comments(vk)
          new_found = true
        else
          if Time.at(topic_hash[:updated]) != topic.updated_at
            topic.get_comments(vk)
            topic.update_attributes(updated_at: Time.at(topic_hash[:updated]))
          end
        end
      end
      if !new_found && !force
        break
      end
    end

  end

  def list_wall(count = 3, offset = 0)
    posts = []
    vk = VkontakteApi::Client.new
    group_id = -(self.vk_id)
    wall = vk_lock { vk.wall.get(owner_id: group_id, count: count, offset: offset, extended: 1) }
    posts_count = wall[:count]
    # puts wall.to_yaml
    wall[:items].each do |wall_item|
      posts.push Post::new_or_create_from_wall(wall_item, {community_id: self.id})
    end
    posts.each do |post|
      post.community_id = self.id
    end
    posts
  end


end
