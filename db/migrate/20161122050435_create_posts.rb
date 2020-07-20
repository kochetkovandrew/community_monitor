class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.references :community
      t.text :header
      t.text :body
      t.integer :from_id
      t.datetime :published_at
      t.integer :relative_id
      t.timestamps null: false
    end
  end
end
