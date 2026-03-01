FactoryBot.define do
  factory :volunteer_assignment do
    association :volunteer
    association :event

    status { "approved" }
    hours_worked { 2.0 }
  end
end