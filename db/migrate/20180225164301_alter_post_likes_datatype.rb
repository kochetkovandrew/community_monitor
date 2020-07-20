class AlterPostLikesDatatype < ActiveRecord::Migration[5.0]
  def change
    change_column :posts, :likes, :jsonb, default: '[]', using: 'likes::jsonb'
  end
end
