class AddMonitorMembersToCommunities < ActiveRecord::Migration[5.0]
  def change
    change_table :communities do |t|
      t.boolean :monitor_members, default: false
    end
  end
end
