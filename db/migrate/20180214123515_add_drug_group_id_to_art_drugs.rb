class AddDrugGroupIdToArtDrugs < ActiveRecord::Migration
  def change
    change_table :art_drugs do |t|
      t.references :drug_group
      t.string :translation
    end
  end
end
