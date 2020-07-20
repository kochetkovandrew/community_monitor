class AddStatusToSubmitNews < ActiveRecord::Migration[5.0]
  def change
    change_table :submit_news do |t|
      t.string :status, default: 'not_handled'
    end
  end
end
