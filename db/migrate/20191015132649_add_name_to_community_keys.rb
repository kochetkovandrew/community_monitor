class AddNameToCommunityKeys < ActiveRecord::Migration[5.2]
  def change
    change_table :community_keys do |t|
      t.text :name
    end
  end
end
