class AddAnswerToSubmitNews < ActiveRecord::Migration[5.0]
  def change
    change_table :submit_news do |t|
      t.text :answer
    end
  end
end
