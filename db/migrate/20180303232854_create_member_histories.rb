class CreateMemberHistories < ActiveRecord::Migration
  def change
    create_table :member_histories do |t|
      t.references :member
      t.string :first_name
      t.string :last_name
      t.jsonb :raw

      t.timestamps null: false
    end
  end
end
