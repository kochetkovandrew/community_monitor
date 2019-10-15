class CommunityKey < ActiveRecord::Base

  def update_admins
    vk_group = VkontakteApi::Client.new key
    resp = vk_lock { vk_group.groups.get_members(group_id: vk_id, filter: 'managers') }
    admins = resp['items'].collect{|item| item['id']}
    save
  end
end
