class CreateOtherDrugs < ActiveRecord::Migration[5.0]
  def change
    create_table :other_drugs do |t|
      t.string :name
      t.text :hidden_name
      t.timestamps null: false
    end
  end
end
