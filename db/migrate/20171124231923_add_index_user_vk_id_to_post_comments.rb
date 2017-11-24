class AddIndexUserVkIdToPostComments < ActiveRecord::Migration
  def change
    add_index :post_comments, :user_vk_id
  end
end
