require "test_helper"

class VolunteerTest < ActiveSupport::TestCase
  test "validations require username, full_name and valid email" do
    v = Volunteer.new
    assert_not v.valid?
    assert_includes v.errors[:username], "can't be blank"
    assert_includes v.errors[:full_name], "can't be blank"
    assert_includes v.errors[:email], "can't be blank"

    v.username = 'unique_user'
    v.full_name = 'Test User'
    v.email = 'not-an-email'
    assert_not v.valid?
    assert_includes v.errors[:email], 'is invalid'
  end

  test "username and email must be unique" do
    existing = volunteers(:one)
    v = Volunteer.new(username: existing.username, full_name: 'X', email: 'other_unique@example.com', password: 'password', password_confirmation: 'password')
    assert_not v.valid?
    assert_includes v.errors[:username], 'has already been taken'

    v2 = Volunteer.new(username: 'another_unique', full_name: 'Y', email: existing.email, password: 'password', password_confirmation: 'password')
    assert_not v2.valid?
    assert_includes v2.errors[:email], 'has already been taken'
  end

  test "total_hours sums only completed assignments" do
    v = volunteers(:one)
    e = Event.create!(title: 'Sample')

    VolunteerAssignment.create!(volunteer: v, event: e, status: 'completed', hours_worked: 2.5)
    VolunteerAssignment.create!(volunteer: v, event: e, status: 'pending', hours_worked: 4.0)
    VolunteerAssignment.create!(volunteer: v, event: e, status: 'completed', hours_worked: 1.0)

    assert_in_delta 3.5, v.total_hours, 0.001
  end
end
