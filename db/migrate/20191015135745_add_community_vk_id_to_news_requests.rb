class AddCommunityVkIdToNewsRequests < ActiveRecord::Migration[5.2]
  def change
    change_table :news_requests do |t|
      t.integer :community_vk_id
    end
  end
end
