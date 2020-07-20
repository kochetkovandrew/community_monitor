class AddMemberIdToPosts < ActiveRecord::Migration[5.0]
  def change
    change_table :posts do |t|
      t.references :member
    end
  end
end
