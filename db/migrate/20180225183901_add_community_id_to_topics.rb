class AddCommunityIdToTopics < ActiveRecord::Migration[5.0]
  def change
    change_table :topics do |t|
      t.references :community
    end
  end
end
