require "test_helper"

class VolunteerAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @volunteer_assignment = volunteer_assignments(:one)
  end

  test "should get index" do
    get volunteer_assignments_url
    assert_response :success
  end

  test "should get new" do
    get new_volunteer_assignment_url
    assert_response :success
  end

  test "should create volunteer_assignment" do
    assert_difference("VolunteerAssignment.count") do
      post volunteer_assignments_url, params: { volunteer_assignment: { date_logged: @volunteer_assignment.date_logged, event_id: @volunteer_assignment.event_id, hours_worked: @volunteer_assignment.hours_worked, status: @volunteer_assignment.status, volunteer_id: @volunteer_assignment.volunteer_id } }
    end

    assert_redirected_to volunteer_assignment_url(VolunteerAssignment.last)
  end

  test "should show volunteer_assignment" do
    get volunteer_assignment_url(@volunteer_assignment)
    assert_response :success
  end

  test "should get edit" do
    get edit_volunteer_assignment_url(@volunteer_assignment)
    assert_response :success
  end

  test "should update volunteer_assignment" do
    patch volunteer_assignment_url(@volunteer_assignment), params: { volunteer_assignment: { date_logged: @volunteer_assignment.date_logged, event_id: @volunteer_assignment.event_id, hours_worked: @volunteer_assignment.hours_worked, status: @volunteer_assignment.status, volunteer_id: @volunteer_assignment.volunteer_id } }
    assert_redirected_to volunteer_assignment_url(@volunteer_assignment)
  end

  test "should destroy volunteer_assignment" do
    assert_difference("VolunteerAssignment.count", -1) do
      delete volunteer_assignment_url(@volunteer_assignment)
    end

    assert_redirected_to volunteer_assignments_url
  end
end
