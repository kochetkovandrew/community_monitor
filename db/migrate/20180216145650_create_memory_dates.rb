class CreateMemoryDates < ActiveRecord::Migration[5.0]
  def change
    create_table :memory_dates do |t|
      t.integer :day
      t.integer :month
      t.integer :year
      t.string :description
      t.string :kind

      t.timestamps null: false
    end
  end
end
