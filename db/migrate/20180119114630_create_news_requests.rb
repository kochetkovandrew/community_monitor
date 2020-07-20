class CreateNewsRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :news_requests do |t|
      t.column :vk_id, :bigint
      t.text :browser

      t.timestamps null: false
    end
  end
end
