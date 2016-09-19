json.extract! room, :id, :room_id, :building, :size, :created_at, :updated_at
json.url room_url(room, format: :json)