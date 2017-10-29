class AddMemberIdToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.references :member
    end
  end
end
