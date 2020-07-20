class AddRawToTopics < ActiveRecord::Migration[5.0]
  def change
    change_table :topics do |t|
      t.jsonb :raw, default: '{}'
    end
  end
end
