class AddCopyHistoryToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.remove :header
      t.text :copy_history
    end
  end
end
