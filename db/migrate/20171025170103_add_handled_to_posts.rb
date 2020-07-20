class AddHandledToPosts < ActiveRecord::Migration[5.0]
  def change
    change_table :posts do |t|
      t.boolean :handled, default: false
    end
  end
end
