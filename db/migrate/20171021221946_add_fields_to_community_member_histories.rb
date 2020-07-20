class AddFieldsToCommunityMemberHistories < ActiveRecord::Migration[5.0]
  def change
    change_table :community_member_histories do |t|
      t.integer :members_count
      t.text :diff
    end
  end
end
