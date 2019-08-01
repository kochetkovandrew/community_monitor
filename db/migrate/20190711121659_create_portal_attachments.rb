class CreatePortalAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :portal_attachments do |t|
      t.string :filename
      t.string :guid

      t.timestamps
    end
  end
end
