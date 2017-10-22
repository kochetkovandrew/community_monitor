class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :screen_name
      t.integer :vk_id
      t.text :name

      t.timestamps null: false
    end
  end
end
