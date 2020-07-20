class AddVkIdToMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.integer :vk_id
    end
  end
end
