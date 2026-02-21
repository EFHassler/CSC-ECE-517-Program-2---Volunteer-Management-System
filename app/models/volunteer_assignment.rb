class VolunteerAssignment < ApplicationRecord
  belongs_to :volunteer
  belongs_to :event

  STATUSES = %w[pending approved completed cancelled].freeze
  validates :status, inclusion: { in: STATUSES }
  validates :hours_worked, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :not_already_signed_up, on: :create
  validate :hours_within_event_duration, if: -> { hours_worked.present? && status == "completed" }

  after_save :update_event_status!
  after_destroy :update_event_status!

  private

  def not_already_signed_up
    return unless volunteer_id && event_id
    if VolunteerAssignment.where(volunteer_id: volunteer_id, event_id: event_id).where.not(status: "cancelled").exists?
      errors.add(:base, "Already signed up for this event")
    end
  end

  def hours_within_event_duration
    return unless event&.start_time && event&.end_time
    duration = ((event.end_time - event.start_time) / 1.hour).abs
    if hours_worked > duration
      errors.add(:hours_worked, "cannot exceed event duration (#{duration} hours)")
    end
  end

  def update_event_status!
    return unless event

    if saved_change_to_status? && status == "approved" && status_was != "approved"
      # Decrease required_volunteers when approving
      if event.required_volunteers > 0
        event.update(required_volunteers: event.required_volunteers - 1)
      end
    elsif destroyed? && status_was == "approved"
      # Increase required_volunteers when approved assignment is destroyed
      event.update(required_volunteers: event.required_volunteers + 1)
    elsif saved_change_to_status? && status_was == "approved" && status != "approved"
      # Increase required_volunteers when status changes away from approved
      event.update(required_volunteers: event.required_volunteers + 1)
    end

    # Update event status based on approved count
    approved_count = event.volunteer_assignments.where(status: "approved").count
    if event.required_volunteers.present? && approved_count >= event.required_volunteers
      event.update(status: "full") if event.status != "completed"
    else
      event.update(status: "open") if event.status == "full"
    end
  end
end
