class AlterPostRawDatatype < ActiveRecord::Migration[5.0]
  def change
    change_table :posts do |t|
      change_column :posts, :raw, :jsonb, default: '{}', using: 'raw::jsonb'
    end
  end
end
