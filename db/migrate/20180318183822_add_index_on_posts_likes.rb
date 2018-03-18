class AddIndexOnPostsLikes < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.index :likes, using: :gin
    end
  end
end
