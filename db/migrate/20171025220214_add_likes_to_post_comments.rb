class AddLikesToPostComments < ActiveRecord::Migration[5.0]
  def change
    change_table :post_comments do |t|
      t.text :likes
    end
  end
end
