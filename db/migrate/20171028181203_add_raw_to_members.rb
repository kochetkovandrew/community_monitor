class AddRawToMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.text :raw
      t.text :raw_friends
    end
  end
end
