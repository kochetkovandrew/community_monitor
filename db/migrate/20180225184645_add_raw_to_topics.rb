class AddRawToTopics < ActiveRecord::Migration
  def change
    change_table :topics do |t|
      t.jsonb :raw, default: '{}'
    end
  end
end
