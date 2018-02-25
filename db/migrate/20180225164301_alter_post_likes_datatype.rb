class AlterPostLikesDatatype < ActiveRecord::Migration
  def change
    change_column :posts, :likes, :jsonb, default: '[]', using: 'likes::jsonb'
  end
end
