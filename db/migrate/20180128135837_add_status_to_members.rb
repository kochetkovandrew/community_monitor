class AddStatusToMembers < ActiveRecord::Migration[5.0]
  def change
    change_table :members do |t|
      t.string :status, default: 'not_viewed'
    end
  end
end
