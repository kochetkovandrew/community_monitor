class DropAttachmentsRenamePhotos < ActiveRecord::Migration
  def change
    drop_table :attachments
    rename_table :photos, :attachments
  end
end
