class CreateArtDrugs < ActiveRecord::Migration
  def change
    create_table :art_drugs do |t|
      t.string :abbreviation
      t.string :name
      t.text :hidden_name

      t.timestamps null: false
    end
  end
end
