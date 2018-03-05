class AddIsFriendIndexToMembers < ActiveRecord::Migration
  def change
    t.index :is_friend
  end
end
