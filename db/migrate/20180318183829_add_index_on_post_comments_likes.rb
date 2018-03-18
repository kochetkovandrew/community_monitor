class AddIndexOnPostCommentsLikes < ActiveRecord::Migration
  def change
    change_table :post_comments do |t|
      t.index :likes, using: :gin
    end
  end
end
