class CreateCopyMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :copy_messages do |t|
      t.references :copy_dialog
      t.integer :user_vk_id
      t.text :body
      t.text :raw

      t.timestamps null: false
    end
  end
end
