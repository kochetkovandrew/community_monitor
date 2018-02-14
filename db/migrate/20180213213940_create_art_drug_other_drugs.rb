class CreateArtDrugOtherDrugs < ActiveRecord::Migration
  def change
    create_table :art_drug_other_drugs do |t|
      t.references :art_drug
      t.references :other_drug
      t.string :interaction, length: 1
      t.timestamps null: false
    end
  end
end
