class AddManuallyAddedToMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.boolean :manually_added, default: true
    end
  end
end
