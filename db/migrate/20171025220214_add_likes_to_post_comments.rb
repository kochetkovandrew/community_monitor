class AddLikesToPostComments < ActiveRecord::Migration
  def change
    change_table :post_comments do |t|
      t.text :likes
    end
  end
end
