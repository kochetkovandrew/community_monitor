class AddRawFollowersToMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.text :raw_followers
    end
  end
end
