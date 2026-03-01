# spec/factories/volunteers.rb

FactoryBot.define do
  factory :volunteer do
    sequence(:username) { |n| "volunteer#{n}" }
    sequence(:email)    { |n| "volunteer#{n}@example.com" }

    full_name { "Test Volunteer" }
    phone     { "555-123-4567" }

    password              { "password123" }
    password_confirmation { "password123" }

    # --------------------------
    # Optional Traits
    # --------------------------

    trait :without_phone do
      phone { nil }
    end

    trait :with_assignments do
      after(:create) do |volunteer|
        create_list(:volunteer_assignment, 2, volunteer: volunteer)
      end
    end

    trait :with_completed_hours do
      after(:create) do |volunteer|
        create(:volunteer_assignment,
               volunteer: volunteer,
               status: "approved",
               hours_worked: 5.5)

        create(:volunteer_assignment,
               volunteer: volunteer,
               status: "completed",
               hours_worked: 4.5)
      end
    end
  end
end