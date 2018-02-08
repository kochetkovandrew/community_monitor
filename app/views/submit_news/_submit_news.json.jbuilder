json.extract! submit_news, :id, :text, :status, :created_at, :updated_at
json.url submit_news_url(submit_news, format: :json)