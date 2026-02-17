require "test_helper"

class VolunteerAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @volunteer_assignment = volunteer_assignments(:one)
  end

  test "volunteer index shows only their assignments" do
    post login_path, params: { username: volunteers(:one).username, password: "password" }
    get volunteer_assignments_url

    assert_response :success
    assigns(:volunteer_assignments).each do |a|
      assert_equal volunteers(:one).id, a.volunteer_id
    end
  end

  test "should get new" do
    get new_volunteer_assignment_url
    assert_response :success
  end

  test "should create volunteer_assignment" do
    # sign in as a volunteer and sign up for an event (creates a pending assignment)
    post login_path, params: { username: volunteers(:two).username, password: "password" }

    assert_difference("VolunteerAssignment.count") do
      post volunteer_assignments_url, params: { volunteer_assignment: { event_id: events(:one).id } }
    end

    assert_redirected_to volunteer_url(volunteers(:two))
  end

  test "cannot sign up for full event" do
    post login_path, params: { username: volunteers(:two).username, password: "password" }
    events(:one).update!(status: "full")

    assert_no_difference("VolunteerAssignment.count") do
      post volunteer_assignments_url, params: { volunteer_assignment: { event_id: events(:one).id } }
    end

    assert_redirected_to events_url
  end

  test "volunteer can view own assignment but not others" do
    owner = @volunteer_assignment.volunteer
    post login_path, params: { username: owner.username, password: "password" }

    get volunteer_assignment_url(@volunteer_assignment)
    assert_response :success

    # try to view an assignment belonging to another volunteer
    other = volunteer_assignments(:two)
    get volunteer_assignment_url(other)
    assert_redirected_to root_url
  end

  test "non-admin cannot access edit or update assignment" do
    owner = @volunteer_assignment.volunteer
    post login_path, params: { username: owner.username, password: "password" }

    get edit_volunteer_assignment_url(@volunteer_assignment)
    assert_redirected_to root_url

    patch volunteer_assignment_url(@volunteer_assignment), params: { volunteer_assignment: { status: "approved" } }
    assert_redirected_to root_url
  end

  test "should destroy volunteer_assignment" do
    # sign in as the volunteer who owns the fixture assignment
    owner = @volunteer_assignment.volunteer
    post login_path, params: { username: owner.username, password: "password" }

    assert_difference("VolunteerAssignment.count", -1) do
      delete volunteer_assignment_url(@volunteer_assignment)
    end

    assert_redirected_to volunteer_url(owner)
  end
end
