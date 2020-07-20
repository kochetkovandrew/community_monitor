class AddTimestampsAndLikesCountToPostComments < ActiveRecord::Migration[5.0]
  def change
    change_table :post_comments do |t|
      t.integer :likes_count
      t.timestamps
    end
  end
end
