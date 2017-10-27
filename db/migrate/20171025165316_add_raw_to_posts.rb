class AddRawToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.text :raw
    end
  end
end
