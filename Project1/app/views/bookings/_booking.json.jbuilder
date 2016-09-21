json.extract! booking, :id, :room_id, :username, :string, :bookday, :date, :starttime, :endtime, :created_at, :updated_at
json.url booking_url(booking, format: :json)