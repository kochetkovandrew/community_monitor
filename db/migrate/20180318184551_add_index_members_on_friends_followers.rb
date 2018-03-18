class AddIndexMembersOnFriendsFollowers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.index :raw_friends, using: :gin
      t.index :raw_followers, using: :gin
    end
  end
end
