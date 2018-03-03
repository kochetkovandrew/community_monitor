class AddIsFriendToMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.boolean :is_friend, null: false, default: false
    end
  end
end
