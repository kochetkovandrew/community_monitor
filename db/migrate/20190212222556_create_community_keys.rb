class CreateCommunityKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :community_keys do |t|
      t.integer :vk_id
      t.string :key

      t.timestamps
    end
  end
end
