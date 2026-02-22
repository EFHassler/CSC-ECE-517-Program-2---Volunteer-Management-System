require 'rails_helper'

RSpec.describe Volunteer, type: :model do
  describe "has_secure_password validation" do
    it { should have_secure_password }
  end

  describe "associations validation" do
    it { should have_many(:volunteer_assignments).dependent(:destroy) }
    it { should have_many(:events).through(:volunteer_assignments) }
  end

  describe "username validation" do
    # validates presence
    it { is_expected.to validate_presence_of(:username) }
    # validates uniqueness
    it { is_expected.to validate_uniqueness_of(:username) }
  end

  describe "password validation" do
    # validates presence
    it { is_expected.to validate_presence_of(:password) }
    # validates password presence when creating a volunteer account
    it "is invalid without a password when created" do
      user = Volunteer.new(password: nil)
      expect(user).to_not be_valid(:create)
    end
  end

  describe "full_name validation" do
    # validates presence
    it { is_expected.to validate_presence_of(:full_name) }
  end

  describe "email validation" do
    subject { Volunteer.new(username: 'test', password: 'test', full_name: 'test') }

    # validates presence
    it { is_expected.to validate_presence_of(:email) }
    # validates uniqueness
    it { is_expected.to validate_uniqueness_of(:email) }
    # validates format
    it { should allow_value("test@address.com").for(:email) }
    it { should_not allow_value("testaddress.com", "test@address_com").for(:email) }
  end

  describe "phone validation" do
    # validates length and checks that it's okay if phone number is blank
    it { should validate_length_of(:phone).is_at_most(20).allow_blank }
  end

  describe "Volunteer methods validation" do
    it "makes sure total_hours functions acts as expected" do
      user = Volunteer.new(username: "test", password: "test", full_name: "test", email: "test@gmail.com")
      # checks total_hours return value is not false or nil
      expect(user.total_hours).to be_truthy
      # checks total_hours return value is a positive number
      expect(user.total_hours).to be >= 0
    end

    it "makes sure completed_hours functions acts as expected" do
      user = Volunteer.new(username: "test", password: "test", full_name: "test", email: "test@gmail.com")
      # checks completed_hours return value is not false or nil
      expect(user.completed_hours).to be_truthy
      # checks completed_hours return value is a positive number
      expect(user.completed_hours).to be >= 0
    end
  end
end
