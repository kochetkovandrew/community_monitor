class AddDrugGroupIdToArtDrugs < ActiveRecord::Migration[5.0]
  def change
    change_table :art_drugs do |t|
      t.references :drug_group
      t.string :translation
    end
  end
end
