class AddNameToNewsRequests < ActiveRecord::Migration[5.0]
  def change
    change_table :news_requests do |t|
      t.string :first_name
      t.string :last_name
      t.string :city_title
      t.string :country_title
    end
  end
end
