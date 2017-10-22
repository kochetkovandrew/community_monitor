class AddFieldsToCommunityMemberHistories < ActiveRecord::Migration
  def change
    change_table :community_member_histories do |t|
      t.integer :members_count
      t.text :diff
    end
  end
end
