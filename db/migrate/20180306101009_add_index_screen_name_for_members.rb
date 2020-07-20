class AddIndexScreenNameForMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.index :screen_name
    end
  end
end
