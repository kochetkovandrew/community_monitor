class AddTopicReferenceToCopyMessages < ActiveRecord::Migration
  def change
    change_table :copy_messages do |t|
      t.references :topic
    end
  end
end
