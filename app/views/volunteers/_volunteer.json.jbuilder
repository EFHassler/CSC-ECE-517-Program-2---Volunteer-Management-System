json.extract! volunteer, :id, :username, :password_digest, :full_name, :email, :phone, :address, :skills, :created_at, :updated_at
json.url volunteer_url(volunteer, format: :json)
