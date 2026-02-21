class AnalyticsController < ApplicationController
  before_action :require_admin_login

  def index
    @date_from = params[:date_from] ? Date.parse(params[:date_from]) : 30.days.ago.to_date
    @date_to = params[:date_to] ? Date.parse(params[:date_to]) : Date.today
    @selected_event_id = params[:event_id]
    @selected_volunteer_id = params[:volunteer_id]

    # Get completed assignments within date range
    assignments = VolunteerAssignment.where(status: "completed")
                                   .where("date_logged >= ? AND date_logged <= ?", @date_from, @date_to)

    # Filter by event if selected
    if @selected_event_id.present?
      assignments = assignments.where(event_id: @selected_event_id)
    end

    # Filter by volunteer if selected
    if @selected_volunteer_id.present?
      assignments = assignments.where(volunteer_id: @selected_volunteer_id)
    end

    # Get all events for filter dropdown
    @events = Event.all.order(:title)
    @volunteers = Volunteer.all.order(:full_name)

    # Volunteer Activity Summary
    @volunteer_activities = Volunteer.left_joins(:volunteer_assignments)
      .where("volunteer_assignments.id IS NULL OR (volunteer_assignments.status = 'completed' AND volunteer_assignments.date_logged >= ? AND volunteer_assignments.date_logged <= ?)", @date_from, @date_to)
      .select("volunteers.id, volunteers.username, volunteers.full_name")
      .group("volunteers.id, volunteers.username, volunteers.full_name")
      .map do |v|
        volunteer_assignments = v.volunteer_assignments.where(status: "completed")
                                        .where("date_logged >= ? AND date_logged <= ?", @date_from, @date_to)
        event_count = volunteer_assignments.count
        total_hrs = volunteer_assignments.sum(:hours_worked).to_f
        avg_hrs = event_count > 0 ? (total_hrs / event_count).round(2) : 0

        {
          volunteer: v,
          event_count: event_count,
          total_hours: total_hrs,
          avg_hours_per_event: avg_hrs
        }
      end

    # Event Participation Summary
    @event_participations = Event.left_joins(:volunteer_assignments)
      .where("volunteer_assignments.id IS NULL OR (volunteer_assignments.status = 'completed' AND volunteer_assignments.date_logged >= ? AND volunteer_assignments.date_logged <= ?)", @date_from, @date_to)
      .select("events.id, events.title")
      .group("events.id, events.title")
      .map do |e|
        event_assignments = e.volunteer_assignments.where(status: "completed")
                                       .where("date_logged >= ? AND date_logged <= ?", @date_from, @date_to)
        volunteer_count = event_assignments.count
        total_hrs = event_assignments.sum(:hours_worked).to_f
        avg_hrs = volunteer_count > 0 ? (total_hrs / volunteer_count).round(2) : 0

        {
          event: e,
          volunteer_count: volunteer_count,
          total_hours: total_hrs,
          avg_hours_per_volunteer: avg_hrs
        }
      end

    # Top Volunteers by Hours
    top_n = (params[:top_n] || 10).to_i
    @top_volunteers_by_hours = @volunteer_activities
      .select { |va| va[:total_hours] > 0 }
      .sort_by { |va| -va[:total_hours] }
      .first(top_n)

    # Top Volunteers by Events
    @top_volunteers_by_events = @volunteer_activities
      .select { |va| va[:event_count] > 0 }
      .sort_by { |va| -va[:event_count] }
      .first(top_n)

    # Low Participation - Volunteers with no completed events
    @no_participation_volunteers = @volunteer_activities
      .select { |va| va[:event_count] == 0 }
      .sort_by { |va| va[:volunteer].full_name }
  end
end
