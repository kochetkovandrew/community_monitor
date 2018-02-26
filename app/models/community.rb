class Community < ActiveRecord::Base
  validates_numericality_of :vk_id, allow_blank: false
  before_validation :set_vk_data
  attr_accessor :posts_count
  has_many :community_members
  has_many :community_member_histories
  has_many :members, :through => :community_members

  def set_vk_data
    self.vk_id = nil
    vk = VkontakteApi::Client.new
    groups = vk_lock { vk.groups.get_by_id(group_id: self.screen_name, fields: [:id]) }
    self.vk_id = groups[0][:id]
    self.name = groups[0][:name]
  rescue
  end

  def get_wall(force = false)
    vk = VkontakteApi::Client.new Settings.vk.user_access_token
    step_size = 100
    begin
      rest = 1
      step = 0
      while rest > 0
        new_found = false
        posts_chunk = vk_lock { vk.wall.get(owner_id: -vk_id, count: step_size, offset: step*step_size, extended: 1) }
        if step == 0
          rest = posts_chunk[:count] - step_size
        else
          rest -= step_size
        end
        step += 1
        items = posts_chunk[:items]
        item_ids = items.collect{|item| item[:id]}
        existing_posts = Post.where(vk_id: item_ids).where(community_id: id).all
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
            post.get_likes
            post.get_comments
            new_found = true
          else
            post = existing_posts_hash[post_hash[:id]]
            if post.raw['likes']['count'] < post_hash[:likes][:count]
              post = existing_posts_hash[post_hash[:id]]
              post.raw['likes']['count'] = post_hash[:likes][:count]
              post.save(touch: false)
              post.get_likes(force)
            end
            if post.post_comments.count < post_hash[:comments][:count]
              post.raw['comments']['count'] = post_hash[:comments][:count]
              post.save(touch: false)
              post.get_comments(force)
            end
          end
        end
        if !new_found
          break
        end
      end
    rescue VkontakteApi::Error => e
      puts e.message
      raise 'Something went wrong'
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
