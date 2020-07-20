class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :kind
      t.integer :vk_id
      t.string :original

      t.timestamps null: false
    end
  end
end
