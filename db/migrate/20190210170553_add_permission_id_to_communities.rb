class AddPermissionIdToCommunities < ActiveRecord::Migration[5.2]
  def change
    change_table :communities do |t|
      t.references :permission
    end
  end
end
