class AddCommunityIdToSubmitNews < ActiveRecord::Migration[5.0]
  def change
    change_table :submit_news do |t|
      t.references :community
    end
  end
end
