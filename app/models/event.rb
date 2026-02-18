class Event < ApplicationRecord
  has_many :volunteer_assignments, dependent: :destroy
  has_many :volunteers, through: :volunteer_assignments

  # Required field validations
  validates :title, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :event_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :required_volunteers, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true

  # Custom validations
  validate :start_before_end, if: -> { start_time.present? && end_time.present? }

  # Status constants
  STATUSES = %w[open full completed].freeze

  def approved_assignments_count
    volunteer_assignments.where(status: "approved").count
  end

  def slots_available?
    return true if required_volunteers.blank?
    approved_assignments_count < required_volunteers
  end

  def open?
    status == "open"
  end

  def full?
    status == "full"
  end

  def completed?
    status == "completed"
  end

  private

  def start_before_end
    errors.add(:start_time, "must be before end time") if start_time >= end_time
  end
end
