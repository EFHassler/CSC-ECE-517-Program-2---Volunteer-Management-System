class VolunteerAssignmentsController < ApplicationController
  before_action :set_volunteer_assignment, only: %i[ show edit update destroy ]
  before_action :authorize_assignment_view, only: %i[ show edit update destroy ]
  before_action :require_volunteer_or_admin, only: %i[ create destroy ]
  before_action :require_admin_login, only: %i[ index ]

  # GET /volunteer_assignments or /volunteer_assignments.json
  def index
    @volunteer_assignments = VolunteerAssignment.all
  end

  # GET /volunteer_assignments/1 or /volunteer_assignments/1.json
  def show
  end

  # GET /volunteer_assignments/new
  def new
    @volunteer_assignment = VolunteerAssignment.new
  end

  # GET /volunteer_assignments/1/edit
  # Only admin may edit assignments (approve/log hours)
  def edit
    require_admin_login
  end

  # POST /volunteer_assignments or /volunteer_assignments.json
  def create
    # Admins may create/assign on behalf of volunteers; volunteers sign up themselves.
    if admin_signed_in?
      @volunteer_assignment = VolunteerAssignment.new(volunteer_assignment_params)
      event = @volunteer_assignment.event
      if event&.completed?
        return redirect_to events_path, alert: "Cannot assign to a completed event"
      end
    else
      event = Event.find(params.require(:volunteer_assignment).require(:event_id))

      unless event.open? && event.slots_available?
        return redirect_to events_path, alert: "Event is not open for sign ups"
      end

      # prevent duplicate sign-ups
      if current_volunteer.volunteer_assignments.exists?(event: event, status: %w[pending approved])
        return redirect_to event, alert: "You have already signed up for this event"
      end

      @volunteer_assignment = current_volunteer.volunteer_assignments.new(event: event, status: "pending")
    end

    respond_to do |format|
      if @volunteer_assignment.save
        if admin_signed_in?
          format.html { redirect_to volunteer_assignments_path, notice: "Volunteer assigned successfully." }
        else
          format.html { redirect_to current_volunteer, notice: "Signed up (pending approval)." }
        end
        format.json { render :show, status: :created, location: @volunteer_assignment }
      else
        # Fall back to a safe path if event is nil
        fallback = event || events_path
        format.html { redirect_to fallback, alert: @volunteer_assignment.errors.full_messages.to_sentence }
        format.json { render json: @volunteer_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volunteer_assignments/1 or /volunteer_assignments/1.json
  # Only admin may change status/hours
  def update
    # Admins can update any attributes; volunteers may only mark their own assignment completed and log hours.
    if admin_signed_in?
      permitted = volunteer_assignment_params
    elsif volunteer_signed_in? && current_volunteer == @volunteer_assignment.volunteer
      permitted = params.require(:volunteer_assignment).permit(:status, :hours_worked, :date_logged)
      if permitted[:status].present? && permitted[:status] != "completed"
        return redirect_to root_path, alert: "Invalid status change"
      end
    else
      redirect_to root_path, alert: "Access denied"
      return
    end

    respond_to do |format|
      if @volunteer_assignment.update(permitted)
        format.html { redirect_to @volunteer_assignment, notice: "Volunteer assignment was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @volunteer_assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @volunteer_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volunteer_assignments/1 or /volunteer_assignments/1.json
  def destroy
    # only the volunteer who signed up (or admin) can withdraw/remove
    unless (volunteer_signed_in? && current_volunteer == @volunteer_assignment.volunteer) || admin_signed_in?
      return redirect_to root_path, alert: "Access denied"
    end

    @volunteer_assignment.destroy!

    respond_to do |format|
      format.html { redirect_to (admin_signed_in? ? volunteer_assignments_path : current_volunteer), notice: "Volunteer assignment was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer_assignment
      @volunteer_assignment = VolunteerAssignment.find(params[:id])
    end

    def authorize_assignment_view
      return if admin_signed_in?
      return if volunteer_signed_in? && current_volunteer == @volunteer_assignment.volunteer

      redirect_to root_path, alert: "Access denied"
    end

    # Only allow a list of trusted parameters through.
    def volunteer_assignment_params
      params.require(:volunteer_assignment).permit(:volunteer_id, :event_id, :status, :hours_worked, :date_logged)
    end

    def require_volunteer_or_admin
      return if volunteer_signed_in? || admin_signed_in?
      redirect_to root_path, alert: "Access denied"
    end
end
