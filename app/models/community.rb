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
    groups = vk.groups.get_by_id(group_id: self.screen_name, fields: [:id])
    self.vk_id = groups[0][:id]
    self.name = groups[0][:name]
  rescue
  end

  def list_wall(count = 3, offset = 0)
    posts = []
    vk = VkontakteApi::Client.new
    group_id = -(self.vk_id)
    wall = vk.wall.get(owner_id: group_id, count: count, offset: offset, extended: 1)
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
