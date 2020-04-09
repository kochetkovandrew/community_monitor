class CreateCalendar2020s < ActiveRecord::Migration[5.2]
  def change
    create_table :calendar2020s do |t|
      t.date :day
      t.text :description

      t.timestamps
    end
  end
end
