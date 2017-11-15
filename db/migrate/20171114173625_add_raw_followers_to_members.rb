class AddRawFollowersToMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.text :raw_followers
    end
  end
end
