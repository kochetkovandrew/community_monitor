class AddCommunityIdToNewsRequests < ActiveRecord::Migration[5.0]
  def change
    change_table :news_requests do |t|
      t.references :community
    end
  end
end
