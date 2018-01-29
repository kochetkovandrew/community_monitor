json.extract! member, :id, :screen_name, :vk_id, :first_name, :last_name, :status, :created_at, :updated_at
json.url member_url(member, format: :json)