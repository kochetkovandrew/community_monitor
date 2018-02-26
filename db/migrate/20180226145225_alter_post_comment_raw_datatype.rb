class AlterPostCommentRawDatatype < ActiveRecord::Migration
  def change
    change_table :post_comments do |t|
      change_column :post_comments, :raw, :jsonb, default: '{}', using: 'raw::jsonb'
    end

  end
end
