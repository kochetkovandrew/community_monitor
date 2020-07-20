class AlterPostCommentLikesDatatype < ActiveRecord::Migration[5.0]
  def change
    change_column :post_comments, :likes, :jsonb, default: '[]', using: 'likes::jsonb'
  end
end
