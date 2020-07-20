class AddIndexUriToPhotos < ActiveRecord::Migration[5.0]
  def change
    change_table :photos do |t|
      t.index :uri
    end
  end
end
