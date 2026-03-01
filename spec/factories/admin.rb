# spec/factories/admins.rb

FactoryBot.define do
  factory :admin do
    sequence(:username) { |n| "admin#{n}" }
    sequence(:email)    { |n| "admin#{n}@example.com" }

    name { "Admin User" }

    password              { "password123" }   # >= 6 chars
    password_confirmation { "password123" }

    # --------------------------
    # Traits
    # --------------------------

    trait :without_password do
      password { nil }
      password_confirmation { nil }
    end

    trait :with_short_password do
      password { "short" }
      password_confirmation { "short" }
    end
  end
end