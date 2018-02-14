class AddDrugGroupIdToOtherDrugs < ActiveRecord::Migration
  def change
    change_table :other_drugs do |t|
      t.references :drug_group
      t.string :translation
    end
  end
end
