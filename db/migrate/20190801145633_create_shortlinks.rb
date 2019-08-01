class CreateShortlinks < ActiveRecord::Migration[5.2]
  def change
    create_table :shortlinks do |t|
      t.text :link
      t.string :short_link

      t.timestamps
    end
  end
end
