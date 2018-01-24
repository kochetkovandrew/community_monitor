class CreateSubmitNews < ActiveRecord::Migration
  def change
    create_table :submit_news do |t|
      t.column :vk_id, :bigint
      t.string :ip_address
      t.text :browser
      t.string :first_name
      t.string :last_name
      t.string :city_title
      t.string :country_title
      t.text :news_text
      t.timestamps null: false
    end
  end
end
