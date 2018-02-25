class AddCommunityIdToTopics < ActiveRecord::Migration
  def change
    change_table :topics do |t|
      t.references :community
    end
  end
end
