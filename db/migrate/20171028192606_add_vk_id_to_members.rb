class AddVkIdToMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.integer :vk_id
    end
  end
end
