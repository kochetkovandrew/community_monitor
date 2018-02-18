class AddCommunityIdToNewsRequests < ActiveRecord::Migration
  def change
    change_table :news_requests do |t|
      t.references :community_id
    end
  end
end
