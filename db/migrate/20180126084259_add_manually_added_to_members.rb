class AddManuallyAddedToMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.boolean :manually_added, default: true
    end
  end
end
