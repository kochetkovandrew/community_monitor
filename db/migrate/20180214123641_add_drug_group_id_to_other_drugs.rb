class AddDrugGroupIdToOtherDrugs < ActiveRecord::Migration[5.0]
  def change
    change_table :other_drugs do |t|
      t.references :drug_group
      t.string :translation
    end
  end
end
