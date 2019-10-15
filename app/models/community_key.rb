class CommunityKey < ActiveRecord::Base

  def update_admins
    vk_group = VkontakteApi::Client.new key
    raw_admins = vk_lock { vk_group.groups.get_members(group_id: vk_id, filter: 'managers') }
    raw_group = vk_lock {
      vk_group.groups.get_by_id(
        group_id: vk_id,
        fields: [:id, :name]
      )
    }[0]
    self.name = raw_group['name']
    self.admins = raw_admins['items'].collect{|item| item['id']}
    self.save
  end
end
