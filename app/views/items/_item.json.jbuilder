json.extract! item, :id, :title, :description, :status, :user_id, :created_at, :updated_at
json.url item_url(item, format: :json)
