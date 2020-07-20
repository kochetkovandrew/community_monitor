class AddCopyIdToCopyDialogs < ActiveRecord::Migration[5.0]
  def change
    change_table :copy_dialogs do |t|
      t.integer :copy_id
    end
  end
end
