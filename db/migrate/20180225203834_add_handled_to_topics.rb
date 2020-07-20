class AddHandledToTopics < ActiveRecord::Migration[5.0]
  def change
    change_table :topics do |t|
      t.boolean :handled, null: false, default: false
    end
  end
end
