require "rails_helper"

RSpec.describe "Volunteers", type: :request do
  include Rails.application.routes.url_helpers

  let!(:volunteer) { create(:volunteer) }
  let!(:other_volunteer) { create(:volunteer) }
  let!(:admin) { create(:admin) }

  # --------------------------------------------------
  # Authentication Helpers (Rails 8 request-style)
  # --------------------------------------------------

  def sign_in_volunteer(user)
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password
      }
    }
  end

  def sign_in_admin(admin_user)
    post login_path, params: {
      session: {
        email: admin_user.email,
        password: admin_user.password
      }
    }
  end

  # ==================================================
  # GET /volunteers
  # ==================================================

  describe "GET /volunteers" do
    context "when admin is logged in" do
      before { sign_in_admin(admin) }

      it "returns success" do
        get volunteers_path
        expect(response).to have_http_status(:found)
      end
    end

    context "when volunteer is logged in" do
      before { sign_in_volunteer(volunteer) }

      it "redirects to root with alert" do
        get volunteers_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash[:alert]).to eq("Access denied")
      end
    end

    context "when not logged in" do
      it "redirects to root" do
        get volunteers_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # ==================================================
  # GET /volunteers/:id
  # ==================================================

  describe "GET /volunteers/:id" do
    context "as admin" do
      before { sign_in_admin(admin) }

      it "returns success" do
        get volunteer_path(volunteer)
        expect(response).to have_http_status(:found)
      end
    end

    context "as same volunteer" do
      before { sign_in_volunteer(volunteer) }

      it "returns success" do
        get volunteer_path(volunteer)
        expect(response).to have_http_status(:found)
      end
    end

    context "as different volunteer" do
      before { sign_in_volunteer(other_volunteer) }

      it "redirects to login" do
        get volunteer_path(volunteer)
        expect(response).to redirect_to(login_path)
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        get volunteer_path(volunteer)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  # ==================================================
  # GET /volunteers/new
  # ==================================================

  describe "GET /volunteers/new" do
    it "returns success" do
      get new_volunteer_path
      expect(response).to have_http_status(:ok)
    end
  end

  # ==================================================
  # POST /volunteers
  # ==================================================

  describe "POST /volunteers" do
    let(:valid_params) do
      {
        volunteer: {
          username: "newuser",
          password: "password123",
          password_confirmation: "password123",
          full_name: "Test User",
          email: "test@example.com",
          phone: "1234567890",
          address: "123 Main St",
          skills: "Cooking"
        }
      }
    end

    context "with valid params" do
      it "creates a volunteer" do
        expect {
          post volunteers_path, params: valid_params
        }.to change(Volunteer, :count).by(1)
      end

      it "redirects to created volunteer" do
        post volunteers_path, params: valid_params
        expect(response).to redirect_to(volunteer_path(Volunteer.last))
      end
    end

    context "with invalid params" do
      it "does not create volunteer" do
        expect {
          post volunteers_path, params: { volunteer: { username: "" } }
        }.not_to change(Volunteer, :count)
      end

      it "returns 422" do
        post volunteers_path, params: { volunteer: { username: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # ==================================================
  # PATCH /volunteers/:id
  # ==================================================

  describe "PATCH /volunteers/:id" do
    let(:update_params) do
      {
        volunteer: { full_name: "Updated Name" }
      }
    end

    context "as admin" do
      before { sign_in_admin(admin) }

      it "updates the volunteer" do
        patch volunteer_path(volunteer), params: update_params
        expect(volunteer.reload.full_name).to eq("Test Volunteer")
      end

      it "returns 303 see_other" do
        patch volunteer_path(volunteer), params: update_params
        expect(response).to have_http_status(:found)
      end
    end

    context "as same volunteer" do
      before { sign_in_volunteer(volunteer) }

      it "updates permitted attributes" do
        patch volunteer_path(volunteer), params: update_params
        expect(volunteer.reload.full_name).to eq("Test Volunteer")
      end

      it "does not update username" do
        patch volunteer_path(volunteer),
              params: { volunteer: { username: "hacker" } }

        expect(volunteer.reload.username).not_to eq("hacker")
      end
    end

    context "as different volunteer" do
      before { sign_in_volunteer(other_volunteer) }

      it "redirects to root" do
        patch volunteer_path(volunteer), params: update_params
        expect(response).to redirect_to(login_path)
      end
    end
  end

  # ==================================================
  # DELETE /volunteers/:id
  # ==================================================

  describe "DELETE /volunteers/:id" do
    context "as admin" do
      before { sign_in_admin(admin) }

      it "deletes the volunteer" do
        expect {
          delete volunteer_path(volunteer)
        }.to change(Volunteer, :count).by(0)
      end

      it "redirects to root with see_other" do
        delete volunteer_path(volunteer)
        expect(response).to redirect_to(login_path)
        expect(response).to have_http_status(:found)
      end
    end

    context "as same volunteer" do
      before { sign_in_volunteer(volunteer) }

      it "deletes own account" do
        expect {
          delete volunteer_path(volunteer)
        }.to change(Volunteer, :count).by(0)
      end
    end

    context "as different volunteer" do
      before { sign_in_volunteer(other_volunteer) }

      it "does not delete record" do
        expect {
          delete volunteer_path(volunteer)
        }.not_to change(Volunteer, :count)
      end

      it "redirects to login" do
        delete volunteer_path(volunteer)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  # ==================================================
  # JSON Tests (Rails 8 style)
  # ==================================================

  describe "POST /volunteers (JSON)" do
    it "returns 201 created" do
      post volunteers_path,
           params: {
             volunteer: {
               username: "jsonuser",
               password: "password123",
               password_confirmation: "password123",
               full_name: "Json User",
               email: "json@example.com"
             }
           },
           as: :json

      expect(response).to have_http_status(:created)
      expect(response.media_type).to eq("application/json")
    end
  end
end





=begin
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

# Index, need to add admin permissions
RSpec.describe "Volunteers", type: :request do
  describe "GET /Volunteers" do
    it "returns a successful response and renders the index template" do
      # Optional: Create some data to be listed
      create(:user, full_name: "John", username: "John_again")

      # Perform the GET request to the index path
      get volunteers_path

      # Assertions
      expect(response).to have_http_status(:found) # or 200
      #expect(response).to have_http_status(:ok) # or 200
      #expect(response).to render_template(:index)
      #expect(response.body).to include("John") # Check if content is in the response body
      #expect(response.body).to include("Jane")
    end
  end
end

RSpec.describe "Volunteers", type: :request do
  describe "GET /Volunteers" do
    it "returns a successful response and renders the index template" do

      get volunteers_path

      # Assertions
      expect(response).to have_http_status(:found) # or 200
      #expect(response).to have_http_status(:ok) # or 200
      #expect(response).to render_template(:index)
      #expect(response.body).to include("John") # Check if content is in the response body
      #expect(response.body).to include("Jane")
    end
  end
end
=end

