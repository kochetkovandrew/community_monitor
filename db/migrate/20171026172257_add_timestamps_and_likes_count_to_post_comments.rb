class AddTimestampsAndLikesCountToPostComments < ActiveRecord::Migration
  def change
    change_table :post_comments do |t|
      t.integer :likes_count
      t.timestamps
    end
  end
end
