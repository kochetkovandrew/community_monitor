class AddAdminsToCommunityKeys < ActiveRecord::Migration[5.2]
  def change
    change_table :community_keys do |t|
      t.jsonb :admins
    end
  end
end
