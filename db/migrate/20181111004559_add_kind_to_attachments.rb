class AddKindToAttachments < ActiveRecord::Migration
  def change
    change_table :attachments do |t|
      t.string :kind
    end
  end
end
