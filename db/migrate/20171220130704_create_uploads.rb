class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :file_name
      t.timestamps null: false
    end
  end
end
