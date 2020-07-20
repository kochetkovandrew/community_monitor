class AddIsFriendToMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.boolean :is_friend, null: false, default: false
    end
  end
end
