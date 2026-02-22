require 'rails_helper'

RSpec.describe Volunteer, type: :model do

  # Validation tests
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }
end
