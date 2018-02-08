class AddStatusToSubmitNews < ActiveRecord::Migration
  def change
    change_table :submit_news do |t|
      t.string :status, default: 'not_handled'
    end
  end
end
