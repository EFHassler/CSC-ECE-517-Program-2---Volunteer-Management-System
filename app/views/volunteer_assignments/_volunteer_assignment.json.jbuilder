json.extract! volunteer_assignment, :id, :volunteer_id, :event_id, :status, :hours_worked, :date_logged, :created_at, :updated_at
json.url volunteer_assignment_url(volunteer_assignment, format: :json)
