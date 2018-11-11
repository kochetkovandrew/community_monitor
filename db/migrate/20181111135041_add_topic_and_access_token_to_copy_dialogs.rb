class AddTopicAndAccessTokenToCopyDialogs < ActiveRecord::Migration
  def change
    change_table :copy_dialogs do |t|
      t.string :title
      t.string :access_key
    end
  end
end
