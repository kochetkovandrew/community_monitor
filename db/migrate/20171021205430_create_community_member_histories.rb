class CreateCommunityMemberHistories < ActiveRecord::Migration
  def change
    create_table :community_member_histories do |t|
      t.references :community
      t.text :members
      t.timestamps null: false
    end
  end
end
