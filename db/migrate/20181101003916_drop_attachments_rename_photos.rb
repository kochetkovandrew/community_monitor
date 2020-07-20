class DropAttachmentsRenamePhotos < ActiveRecord::Migration[5.0]
  def change
    drop_table :attachments
    rename_table :photos, :attachments
  end
end
