class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.text :title
      t.integer :created_by_vk_id
      t.timestamps
    end
  end
end
