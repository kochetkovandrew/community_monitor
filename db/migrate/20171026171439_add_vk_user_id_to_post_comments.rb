class AddVkUserIdToPostComments < ActiveRecord::Migration[5.0]
  def change
    change_table :post_comments do |t|
      t.integer :user_vk_id
    end
  end
end
