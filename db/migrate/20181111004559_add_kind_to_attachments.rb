class AddKindToAttachments < ActiveRecord::Migration[5.0]
  def change
    change_table :attachments do |t|
      t.string :kind
    end
  end
end
