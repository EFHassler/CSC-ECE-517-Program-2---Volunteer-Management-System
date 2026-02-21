class Volunteer < ApplicationRecord
  has_secure_password

  has_many :volunteer_assignments, dependent: :destroy
  has_many :events, through: :volunteer_assignments

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, length: { maximum: 20 }, allow_blank: true

  # Returns total hours from approved and completed assignments (float)
  def total_hours
    volunteer_assignments.where(status: [ "approved", "completed" ]).sum(:hours_worked).to_f
  end

  # Returns total hours from approved and completed assignments (includes both approved and completed)
  def completed_hours
    volunteer_assignments.where(status: [ "approved", "completed" ]).sum(:hours_worked).to_f
  end
end
