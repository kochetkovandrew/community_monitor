class AddCommunityIdToSubmitNews < ActiveRecord::Migration
  def change
    change_table :submit_news do |t|
      t.references :community_id
    end
  end
end
