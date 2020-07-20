class AddLastResentMessageIdToCopyDialogs < ActiveRecord::Migration[5.0]
  def change
    change_table :copy_dialogs do |t|
      t.column :last_resent_message_id, :bigint, null: false, default: 0
    end
  end
end
