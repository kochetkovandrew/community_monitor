class AddIsFriendIndexToMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.index :is_friend
    end
  end
end
