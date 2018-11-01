class AddTitleToAttachments < ActiveRecord::Migration
  def change
    change_table :attachments do |t|
      t.string :title
    end
  end
end
