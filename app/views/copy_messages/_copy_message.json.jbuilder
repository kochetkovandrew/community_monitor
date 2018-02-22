json.extract! copy_message, :id, :user_vk_id, :body, :raw, :created_at, :updated_at
json.url copy_message_url(copy_message, format: :json)
