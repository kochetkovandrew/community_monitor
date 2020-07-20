class AddVkIdToPosts < ActiveRecord::Migration[5.0]
  def change
    change_table :posts do |t|
      t.integer :vk_id
    end
  end
end
