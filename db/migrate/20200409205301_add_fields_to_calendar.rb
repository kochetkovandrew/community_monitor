class AddFieldsToCalendar < ActiveRecord::Migration[5.2]
  def change
    change_table :calendar2020s do |t|
      t.boolean :has_picture, null: false, default: false
      t.string :header, null: false, default: ''
      t.string :footer, null: false, default: ''
    end
  end
end
