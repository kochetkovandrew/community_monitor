class CreateUmfrages < ActiveRecord::Migration[5.2]
  def change
    create_table :umfrages do |t|
      t.text :result
      t.text :ip_address

      t.timestamps
    end
  end
end
