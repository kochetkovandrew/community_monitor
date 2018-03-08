class AddIsHandledIsMonitoredToMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.boolean :is_handled, null: false, default: false
      t.boolean :is_monitored, null: false, default: false
      Member.where(is_friend: false).update_all({is_monitored: true, is_handled: true})
      t.index :is_handled
      t.index :is_monitored
    end
  end
end
