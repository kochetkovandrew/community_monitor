class AddHandledToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.boolean :handled, default: false
    end
  end
end
