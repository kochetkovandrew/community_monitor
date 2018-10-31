class AddLocalFilenameToPhotos < ActiveRecord::Migration
  def change
    change_table :photos do |t|
      t.string :local_filename
    end
  end
end
