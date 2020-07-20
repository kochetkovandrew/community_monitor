class AddIndexOnPostsLikes < ActiveRecord::Migration[5.0]
  def change
    change_table :posts do |t|
      t.index :likes, using: :gin
    end
  end
end
