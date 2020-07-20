class AddLocalFilenameToPhotos < ActiveRecord::Migration[5.0]
  def change
    change_table :photos do |t|
      t.string :local_filename
    end
  end
end
