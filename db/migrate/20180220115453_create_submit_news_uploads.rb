class CreateSubmitNewsUploads < ActiveRecord::Migration
  def change
    create_table :submit_news_uploads do |t|
      t.references :submit_news
      t.references :uploads
      t.timestamps null: false
    end
  end
end
