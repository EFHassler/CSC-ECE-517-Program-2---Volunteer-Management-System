require "test_helper"

class VolunteersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @volunteer = volunteers(:one)
  end

  test "should not allow access to volunteers index for non-admins" do
    get volunteers_url
    assert_redirected_to root_url
  end

  test "should get new" do
    get new_volunteer_url
    assert_response :success
  end

  test "should create volunteer" do
    assert_difference("Volunteer.count") do
      post volunteers_url, params: { volunteer: { address: "123 New St", email: "new_volunteer@example.com", full_name: "New Volunteer", password: "password", password_confirmation: "password", phone: "555-0000", skills: "none", username: "new_volunteer" } }
    end

    assert_redirected_to volunteer_url(Volunteer.last)
  end

  test "should show volunteer" do
    post login_path, params: { username: @volunteer.username, password: "password" }
    get volunteer_url(@volunteer)
    assert_response :success
  end

  test "should get edit" do
    post login_path, params: { username: @volunteer.username, password: "password" }
    get edit_volunteer_url(@volunteer)
    assert_response :success
  end

  test "should update volunteer" do
    post login_path, params: { username: @volunteer.username, password: "password" }
    patch volunteer_url(@volunteer), params: { volunteer: { address: @volunteer.address, email: @volunteer.email, full_name: @volunteer.full_name, phone: @volunteer.phone, skills: @volunteer.skills } }
    assert_redirected_to volunteer_url(@volunteer)
  end
  test "volunteer cannot edit another volunteer" do
    other = volunteers(:two)
    post login_path, params: { username: @volunteer.username, password: "password" }
    get edit_volunteer_path(other)
    assert_redirected_to root_url
  end
  test "should destroy volunteer" do
    post login_path, params: { username: @volunteer.username, password: "password" }

    assert_difference("Volunteer.count", -1) do
      delete volunteer_url(@volunteer)
    end

    assert_redirected_to root_url
  end
end
