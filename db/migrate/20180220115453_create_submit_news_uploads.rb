class CreateSubmitNewsUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :submit_news_uploads do |t|
      t.references :submit_news
      t.references :upload
      t.timestamps null: false
    end
  end
end
