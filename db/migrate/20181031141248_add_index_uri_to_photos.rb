class AddIndexUriToPhotos < ActiveRecord::Migration
  def change
    change_table :photos do |t|
      t.index :uri
    end
  end
end
