class AddIndexOnPostCommentsLikes < ActiveRecord::Migration[5.0]
  def change
    change_table :post_comments do |t|
      t.index :likes, using: :gin
    end
  end
end
