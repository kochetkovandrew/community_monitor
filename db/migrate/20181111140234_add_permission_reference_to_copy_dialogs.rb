class AddPermissionReferenceToCopyDialogs < ActiveRecord::Migration[5.0]
  def change
    change_table :copy_dialogs do |t|
      t.references :permission
    end
  end
end
