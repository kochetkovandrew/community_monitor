class AddLikesHandledToPosts < ActiveRecord::Migration[5.0]
  def change
    change_table :posts do |t|
      t.boolean :likes_handled, default: false
    end
  end
end
