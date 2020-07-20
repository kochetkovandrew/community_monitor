class AddFieldsToMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.integer :sex
      t.datetime :last_seen_at
      t.integer :last_seen_platform
      t.integer :city_id
      t.string :city_title
      t.integer :country_id
      t.string :country_title
      t.string :domain
      t.string :first_name
      t.string :last_name
      t.string :home_town
      t.string :maiden_name
      t.string :nickname
      t.string :screen_name
      # # for each table that will store unicode execute:
      # execute "ALTER TABLE table_name CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
      # # for each string/text column with unicode content execute:
      # execute "ALTER TABLE table_name CHANGE column_name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    end
  end
end
