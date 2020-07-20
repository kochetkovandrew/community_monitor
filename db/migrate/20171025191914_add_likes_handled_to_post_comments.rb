class AddLikesHandledToPostComments < ActiveRecord::Migration[5.0]
  def change
    change_table :post_comments do |t|
      t.boolean :likes_handled, default: false
    end
  end
end
