class AddMonitorMembersToCommunities < ActiveRecord::Migration
  def change
    change_table :communities do |t|
      t.boolean :monitor_members, default: false
    end
  end
end
