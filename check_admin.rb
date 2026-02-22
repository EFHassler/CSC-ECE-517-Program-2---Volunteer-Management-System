#!/usr/bin/env ruby

require_relative 'config/environment'

# Delete the invalid admin "Emma"
invalid_admin = Admin.find_by(username: "Emma")
if invalid_admin
  invalid_admin.destroy
  puts "Deleted invalid admin 'Emma'"
else
  puts "No 'Emma' admin found"
end

# Check remaining admins
admins = Admin.all
puts "Remaining admins: #{admins.count}"
admins.each do |admin|
  puts "Admin: #{admin.username}, #{admin.name}"
end
