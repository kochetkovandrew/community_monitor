class AddTopicAndAccessTokenToCopyDialogs < ActiveRecord::Migration[5.0]
  def change
    change_table :copy_dialogs do |t|
      t.string :title
      t.string :access_key
    end
  end
end
