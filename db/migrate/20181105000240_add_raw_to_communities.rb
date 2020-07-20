class AddRawToCommunities < ActiveRecord::Migration[5.0]
  def change
    change_table :communities do |t|
      t.jsonb :raw
    end
  end
end
