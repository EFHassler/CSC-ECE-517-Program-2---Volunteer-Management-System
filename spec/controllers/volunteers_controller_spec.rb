#require "test_helper"
require 'rails_helper'

RSpec.describe VolunteersController, type: :request do
  it "gets new" do
    get new_volunteer_url
    expect(response).to be_successful
  end

  it "creates a volunteer" do
    volunteer_params = {
      address: "123 New St",
      email: "new_volunteer@example.com",
      full_name: "New Volunteer",
      password: "password",
      password_confirmation: "password",
      phone: "555-0000",
      skills: "none",
      username: "new_volunteer"
    }

    expect {
      post volunteers_url, params: { volunteer: volunteer_params }
    }.to change(Volunteer, :count).by(1)
  end
end
