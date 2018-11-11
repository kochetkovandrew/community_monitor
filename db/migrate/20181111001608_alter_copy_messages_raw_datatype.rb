class AlterCopyMessagesRawDatatype < ActiveRecord::Migration
  def change
    change_table :copy_messages do |t|
      change_column :copy_messages, :raw, :jsonb, default: '{}', using: 'raw::jsonb'
    end
  end
end
