class AlterMembersRawDatatypes < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      change_column :members, :raw, :jsonb, default: '{}', using: 'raw::jsonb'
      change_column :members, :raw_friends, :jsonb, default: '[]', using: 'raw_friends::jsonb'
    end
  end
end
