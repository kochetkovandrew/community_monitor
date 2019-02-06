class AddVkIdToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.integer :vk_id
    end
  end
end
