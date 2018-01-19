class CreateNewsRequests < ActiveRecord::Migration
  def change
    create_table :news_requests do |t|
      t.column :vk_id, :bigint
      t.text :browser

      t.timestamps null: false
    end
  end
end
