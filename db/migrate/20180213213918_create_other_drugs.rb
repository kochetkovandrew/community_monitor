class CreateOtherDrugs < ActiveRecord::Migration
  def change
    create_table :other_drugs do |t|
      t.string :name
      t.text :hidden_name
      t.timestamps null: false
    end
  end
end
