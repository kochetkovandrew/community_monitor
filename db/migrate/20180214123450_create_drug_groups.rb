class CreateDrugGroups < ActiveRecord::Migration
  def change
    create_table :drug_groups do |t|
      t.string :name
      t.string :translation

      t.timestamps null: false
    end
  end
end
