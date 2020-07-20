class AddAccessTokenToCommunities < ActiveRecord::Migration[5.0]
  def change
    change_table :communities do |t|
      t.string :access_token
    end
  end
end
