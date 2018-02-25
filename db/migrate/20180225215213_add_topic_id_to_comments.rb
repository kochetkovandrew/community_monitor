class AddTopicIdToComments < ActiveRecord::Migration
  def change
    change_table :post_comments do |t|
      t.references :topic
    end
  end
end
