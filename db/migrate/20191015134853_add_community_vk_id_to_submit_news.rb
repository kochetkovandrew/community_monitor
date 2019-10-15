class AddCommunityVkIdToSubmitNews < ActiveRecord::Migration[5.2]
  def change
    change_table :submit_news do |t|
      t.integer :community_vk_id
    end
  end
end
