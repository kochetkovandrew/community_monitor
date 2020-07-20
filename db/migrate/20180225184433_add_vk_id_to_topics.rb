class AddVkIdToTopics < ActiveRecord::Migration[5.0]
  def change
    change_table :topics do |t|
      t.column :vk_id, :bigint, null: false, default: 0
    end
  end
end
