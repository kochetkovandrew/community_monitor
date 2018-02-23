class AlterPostCommentLikesDatatype < ActiveRecord::Migration
  def change
    change_column :post_comments, :likes, :jsonb, default: '[]', using: 'likes::jsonb'
  end
end
