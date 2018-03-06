class AddIndexScreenNameForMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.index :screen_name
    end
  end
end
