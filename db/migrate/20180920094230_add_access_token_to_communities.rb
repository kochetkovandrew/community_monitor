class AddAccessTokenToCommunities < ActiveRecord::Migration
  def change
    change_table :communities do |t|
      t.string :access_token
    end
  end
end
