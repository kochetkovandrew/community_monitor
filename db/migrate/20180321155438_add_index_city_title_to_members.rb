class AddIndexCityTitleToMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.index :city_title
    end
  end
end
