class AddRawToMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.text :raw
      t.text :raw_friends
    end
  end
end
