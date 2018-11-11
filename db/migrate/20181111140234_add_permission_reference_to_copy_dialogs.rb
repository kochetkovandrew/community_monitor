class AddPermissionReferenceToCopyDialogs < ActiveRecord::Migration
  def change
    change_table :copy_dialogs do |t|
      t.references :permission
    end
  end
end
