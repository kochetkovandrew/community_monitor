class AddRawToCommunities < ActiveRecord::Migration
  def change
    change_table :communities do |t|
      t.jsonb :raw
    end
  end
end
