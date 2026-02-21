class VolunteersController < ApplicationController
  before_action :set_volunteer, only: %i[ show edit update destroy ]
  before_action :require_volunteer_or_admin_login, only: %i[ show edit update destroy ]
  before_action :authorize_volunteer_or_admin, only: %i[ show edit update destroy ]

  # GET /volunteers or /volunteers.json
  # Only admins should be able to view the full volunteers list. Redirect everyone else.
  def index
    if session[:admin_id].present?
      @volunteers = Volunteer.all
    else
      redirect_to root_path, alert: "Access denied"
    end
  end

  # GET /volunteers/1 or /volunteers/1.json
  def show
  end

  # GET /volunteers/new
  def new
    @volunteer = Volunteer.new
  end

  # GET /volunteers/1/edit
  def edit
  end

  # POST /volunteers or /volunteers.json
  def create
    @volunteer = Volunteer.new(volunteer_params)

    respond_to do |format|
      if @volunteer.save
        session[:volunteer_id] = @volunteer.id
        format.html { redirect_to @volunteer, notice: "Volunteer was successfully created." }
        format.json { render :show, status: :created, location: @volunteer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @volunteer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volunteers/1 or /volunteers/1.json
  def update
    respond_to do |format|
      if @volunteer.update(volunteer_update_params)
        format.html { redirect_to @volunteer, notice: "Volunteer was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @volunteer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @volunteer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volunteers/1 or /volunteers/1.json
  def destroy
    @volunteer.destroy!
    reset_session if session[:volunteer_id] == @volunteer.id

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Volunteer was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer
      @volunteer = Volunteer.find(params[:id])
    end

    def authorize_volunteer
      require_same_volunteer!(@volunteer)
    end

    def require_volunteer_or_admin_login
      unless volunteer_signed_in? || admin_signed_in?
        redirect_to login_path, alert: "Please log in"
      end
    end

    def authorize_volunteer_or_admin
      # Allow if admin or if the volunteer is viewing/editing their own profile
      unless admin_signed_in? || (volunteer_signed_in? && current_volunteer == @volunteer)
        redirect_to root_path, alert: "Access denied"
      end
    end

    # Only allow a list of trusted parameters through for create.
    def volunteer_params
      params.require(:volunteer).permit(:username, :password, :password_confirmation, :full_name, :email, :phone, :address, :skills)
    end

    # Parameters allowed when a volunteer updates their profile (username cannot be changed)
    def volunteer_update_params
      params.require(:volunteer).permit(:password, :password_confirmation, :full_name, :email, :phone, :address, :skills)
    end
end
