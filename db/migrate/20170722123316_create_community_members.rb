class CreateCommunityMembers < ActiveRecord::Migration
  def change
    create_table :community_members do |t|
      t.references :community
      t.references :member
      t.timestamps
    end
  end
end
