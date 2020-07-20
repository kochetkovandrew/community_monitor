class CreateCopyDialogs < ActiveRecord::Migration[5.0]
  def change
    create_table :copy_dialogs do |t|
      t.column :source_id, :bigint
      t.column :recipient_id, :bigint
      t.column :last_message_id, :bigint, null: false, default: 0
      t.timestamps null: false
    end
  end
end
