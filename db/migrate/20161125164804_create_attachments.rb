class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :kind
      t.integer :vk_id
      t.string :original

      t.timestamps null: false
    end
  end
end
