class AddDisabledToCommunities < ActiveRecord::Migration[5.2]
  def change
    change_table :communities do |t|
      t.boolean :disabled
    end
  end
end
