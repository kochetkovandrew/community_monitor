class AddUniqueVkIdForMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.index [:vk_id], unique: true
    end
  end
end
