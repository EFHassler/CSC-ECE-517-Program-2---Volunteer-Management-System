class VolunteerAssignmentsController < ApplicationController
  before_action :set_volunteer_assignment, only: %i[ show edit update destroy ]

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
  def edit
  end

  # POST /volunteer_assignments or /volunteer_assignments.json
  def create
    @volunteer_assignment = VolunteerAssignment.new(volunteer_assignment_params)

    respond_to do |format|
      if @volunteer_assignment.save
        format.html { redirect_to @volunteer_assignment, notice: "Volunteer assignment was successfully created." }
        format.json { render :show, status: :created, location: @volunteer_assignment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @volunteer_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volunteer_assignments/1 or /volunteer_assignments/1.json
  def update
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
    @volunteer_assignment.destroy!

    respond_to do |format|
      format.html { redirect_to volunteer_assignments_path, notice: "Volunteer assignment was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer_assignment
      @volunteer_assignment = VolunteerAssignment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def volunteer_assignment_params
      params.expect(volunteer_assignment: [ :volunteer_id, :event_id, :status, :hours_worked, :date_logged ])
    end
end
