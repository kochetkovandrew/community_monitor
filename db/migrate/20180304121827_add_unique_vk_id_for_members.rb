class AddUniqueVkIdForMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.index [:vk_id], unique: true
    end
  end
end
