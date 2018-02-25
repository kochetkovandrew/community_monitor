class AddHandledToTopics < ActiveRecord::Migration
  def change
    change_table :topics do |t|
      t.boolean :handled, null: false, default: false
    end
  end
end
