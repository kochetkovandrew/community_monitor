class AddIndexesToPostComments < ActiveRecord::Migration
  def change
    change_table :post_comments do |t|
      t.index [:post_id, :created_at]
      t.index [:topic_id, :created_at]
    end
  end
end
