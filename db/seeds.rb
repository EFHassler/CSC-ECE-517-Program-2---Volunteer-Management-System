# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a default admin account (only one admin)
Admin.find_or_create_by!(username: "admin") do |admin|
  admin.password = "admin123"
  admin.name = "System Administrator"
  admin.email = "admin@example.com"
end

# Create test volunteers
volunteer1 = Volunteer.find_or_create_by!(username: "john_doe") do |v|
  v.password = "password123"
  v.full_name = "John Doe"
  v.email = "john@example.com"
  v.phone = "555-0101"
  v.address = "123 Main St"
  v.skills = "Event Planning, First Aid"
end

volunteer2 = Volunteer.find_or_create_by!(username: "jane_smith") do |v|
  v.password = "password123"
  v.full_name = "Jane Smith"
  v.email = "jane@example.com"
  v.phone = "555-0102"
  v.address = "456 Oak Ave"
  v.skills = "Cooking, Driving"
end

volunteer3 = Volunteer.find_or_create_by!(username: "bob_wilson") do |v|
  v.password = "password123"
  v.full_name = "Bob Wilson"
  v.email = "bob@example.com"
  v.phone = "555-0103"
  v.address = "789 Pine Rd"
  v.skills = "Photography, Technical Support"
end

volunteer4 = Volunteer.find_or_create_by!(username: "alice_brown") do |v|
  v.password = "password123"
  v.full_name = "Alice Brown"
  v.email = "alice@example.com"
  v.phone = "555-0104"
  v.address = "321 Elm St"
  v.skills = "Cleaning, Organization"
end

# Create test events
event1 = Event.find_or_create_by!(title: "Community Cleanup Day") do |e|
  e.description = "Help clean up the local park and community areas"
  e.location = "Central Park"
  e.event_date = Date.today - 15.days
  e.start_time = DateTime.now - 15.days + 9.hours
  e.end_time = DateTime.now - 15.days + 13.hours
  e.required_volunteers = 5
  e.status = "completed"
end

event2 = Event.find_or_create_by!(title: "Food Bank Distribution") do |e|
  e.description = "Help distribute food to those in need"
  e.location = "Community Center"
  e.event_date = Date.today - 10.days
  e.start_time = DateTime.now - 10.days + 8.hours
  e.end_time = DateTime.now - 10.days + 14.hours
  e.required_volunteers = 8
  e.status = "completed"
end

event3 = Event.find_or_create_by!(title: "Charity Fundraiser") do |e|
  e.description = "Annual charity dinner and auction"
  e.location = "Hotel Ballroom"
  e.event_date = Date.today - 5.days
  e.start_time = DateTime.now - 5.days + 17.hours
  e.end_time = DateTime.now - 5.days + 22.hours
  e.required_volunteers = 10
  e.status = "completed"
end

event4 = Event.find_or_create_by!(title: "Senior Center Visit") do |e|
  e.description = "Spend time with seniors at the local center"
  e.location = "Sunshine Senior Center"
  e.event_date = Date.today + 7.days
  e.start_time = DateTime.now + 7.days + 10.hours
  e.end_time = DateTime.now + 7.days + 14.hours
  e.required_volunteers = 4
  e.status = "open"
end

event5 = Event.find_or_create_by!(title: "Youth Sports Day") do |e|
  e.description = "Organize sports activities for local youth"
  e.location = "Recreation Field"
  e.event_date = Date.today + 14.days
  e.start_time = DateTime.now + 14.days + 9.hours
  e.end_time = DateTime.now + 14.days + 16.hours
  e.required_volunteers = 6
  e.status = "open"
end

# Create volunteer assignments (some completed with hours, some pending/approved)
# Event 1: Community Cleanup Day (completed)
assignment1 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer1, event: event1) do |a|
  a.status = "completed"
  a.hours_worked = 4.0
  a.date_logged = event1.event_date
end
assignment1.update(status: "completed", hours_worked: 4.0, date_logged: event1.event_date) rescue nil

assignment2 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer2, event: event1) do |a|
  a.status = "completed"
  a.hours_worked = 3.5
  a.date_logged = event1.event_date
end

assignment3 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer3, event: event1) do |a|
  a.status = "completed"
  a.hours_worked = 4.0
  a.date_logged = event1.event_date
end

# Event 2: Food Bank Distribution (completed)
assignment4 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer1, event: event2) do |a|
  a.status = "completed"
  a.hours_worked = 5.0
  a.date_logged = event2.event_date
end

assignment5 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer4, event: event2) do |a|
  a.status = "completed"
  a.hours_worked = 6.0
  a.date_logged = event2.event_date
end

# Event 3: Charity Fundraiser (completed)
assignment6 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer2, event: event3) do |a|
  a.status = "completed"
  a.hours_worked = 5.0
  a.date_logged = event3.event_date
end

assignment7 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer3, event: event3) do |a|
  a.status = "completed"
  a.hours_worked = 4.5
  a.date_logged = event3.event_date
end

assignment8 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer4, event: event3) do |a|
  a.status = "completed"
  a.hours_worked = 5.0
  a.date_logged = event3.event_date
end

# Event 4: Senior Center Visit (upcoming - pending/approved)
assignment9 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer1, event: event4) do |a|
  a.status = "approved"
  a.hours_worked = nil
  a.date_logged = nil
end

assignment10 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer2, event: event4) do |a|
  a.status = "pending"
  a.hours_worked = nil
  a.date_logged = nil
end

# Event 5: Youth Sports Day (upcoming - pending)
assignment11 = VolunteerAssignment.find_or_create_by!(volunteer: volunteer3, event: event5) do |a|
  a.status = "pending"
  a.hours_worked = nil
  a.date_logged = nil
end

puts "Seed data created successfully!"
puts "Admin: username='admin', password='admin123'"
puts "Volunteers: john_doe, jane_smith, bob_wilson, alice_brown (password='password123')"
puts "Events: 3 completed, 2 upcoming"
puts "Assignments: 8 completed with hours, 3 pending/approved"
