class CreateMemberLastSeens < ActiveRecord::Migration
  def change
    create_table :member_last_seens do |t|
      t.references :member
      t.datetime :last_seen_at
      t.integer :last_seen_platform
      t.timestamps null: false
    end
  end
end
