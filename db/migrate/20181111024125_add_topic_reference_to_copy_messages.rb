class AddTopicReferenceToCopyMessages < ActiveRecord::Migration[5.0]
  def change
    change_table :copy_messages do |t|
      t.references :topic
    end
  end
end
