class VolunteerAssignmentsController < ApplicationController
  before_action :set_volunteer_assignment, only: %i[ show edit update destroy ]
  before_action :require_volunteer_login, only: %i[ create destroy ]

  # GET /volunteer_assignments or /volunteer_assignments.json
  def index
    if admin_signed_in?
      @volunteer_assignments = VolunteerAssignment.all
    elsif volunteer_signed_in?
      @volunteer_assignments = current_volunteer.volunteer_assignments
    else
      redirect_to root_path, alert: "Access denied"
    end
  end

  # GET /volunteer_assignments/1 or /volunteer_assignments/1.json
  def show
    authorize_assignment_view
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
    event = Event.find(params.require(:volunteer_assignment).require(:event_id))

    unless event.open? && event.slots_available?
      return redirect_to events_path, alert: "Event is not open for sign ups"
    end

    # prevent duplicate sign-ups
    if current_volunteer.volunteer_assignments.exists?(event: event, status: %w[pending approved])
      return redirect_to event, alert: "You have already signed up for this event"
    end

    @volunteer_assignment = current_volunteer.volunteer_assignments.new(event: event, status: "pending")

    respond_to do |format|
      if @volunteer_assignment.save
        format.html { redirect_to current_volunteer, notice: "Signed up (pending approval)." }
        format.json { render :show, status: :created, location: @volunteer_assignment }
      else
        format.html { redirect_to event, alert: @volunteer_assignment.errors.full_messages.to_sentence }
        format.json { render json: @volunteer_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volunteer_assignments/1 or /volunteer_assignments/1.json
  # Only admin may change status/hours
  def update
    unless admin_signed_in?
      redirect_to root_path, alert: "Admin access required"
      return
    end

    respond_to do |format|
      if @volunteer_assignment.update(volunteer_assignment_params)
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
end
