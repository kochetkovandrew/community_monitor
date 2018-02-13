class AddAnswerToSubmitNews < ActiveRecord::Migration
  def change
    change_table :submit_news do |t|
      t.text :answer
    end
  end
end
