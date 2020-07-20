class AddIndexCityTitleToMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.index :city_title
    end
  end
end
