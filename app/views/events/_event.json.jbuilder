json.extract! event, :id, :title, :description, :location, :event_date, :start_time, :end_time, :required_volunteers, :status, :created_at, :updated_at
json.url event_url(event, format: :json)
