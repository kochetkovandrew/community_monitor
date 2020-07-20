class CreatePermissionUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :permission_users do |t|
      t.references :permission
      t.references :user
      t.timestamps
    end
  end
end
