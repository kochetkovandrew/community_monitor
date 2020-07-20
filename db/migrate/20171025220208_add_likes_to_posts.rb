class AddLikesToPosts < ActiveRecord::Migration[5.0]
  def change
    change_table :posts do |t|
      t.text :likes
    end
  end
end
