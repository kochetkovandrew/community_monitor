class CreateShortlinkHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :shortlink_histories do |t|
      t.references :shortlink
      t.string :ip_address
      t.string :browser
      t.timestamps
    end
  end
end
