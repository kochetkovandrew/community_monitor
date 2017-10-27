class AddLikesToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.text :likes
    end
  end
end
