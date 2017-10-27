class AddVkIdToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.integer :vk_id
    end
  end
end
