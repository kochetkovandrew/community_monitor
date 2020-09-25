class ChangeDisabledToCommunities < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:communities, :disabled, false, false)
  end
end
