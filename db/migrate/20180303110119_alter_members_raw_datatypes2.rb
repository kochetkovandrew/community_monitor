class AlterMembersRawDatatypes2 < ActiveRecord::Migration
  def change
    change_table :members do |t|
      change_column :members, :raw_followers, :jsonb, default: '[]', using: 'raw_followers::jsonb'
    end
  end
end
