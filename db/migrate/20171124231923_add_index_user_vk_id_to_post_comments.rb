class AddIndexUserVkIdToPostComments < ActiveRecord::Migration[5.0]
  def change
    add_index :post_comments, :user_vk_id
  end
end
