class AddTopicIdToComments < ActiveRecord::Migration[5.0]
  def change
    change_table :post_comments do |t|
      t.references :topic
    end
  end
end
