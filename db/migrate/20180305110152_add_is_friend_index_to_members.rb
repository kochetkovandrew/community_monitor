class AddIsFriendIndexToMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.index :is_friend
    end
  end
end
