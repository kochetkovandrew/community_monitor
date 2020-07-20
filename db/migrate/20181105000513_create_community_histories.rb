class CreateCommunityHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :community_histories do |t|
      t.references :community
      t.string :first_name
      t.string :last_name
      t.jsonb :raw

      t.timestamps null: false
    end
  end
end
