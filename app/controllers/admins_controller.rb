class AdminsController < ApplicationController
  before_action :set_admin, only: %i[ show edit update destroy ]
  before_action :require_admin_login, only: %i[ index show edit update ]

  # GET /admins or /admins.json
  def index
    @admins = Admin.all
  end

  # GET /admins/1 or /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins or /admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to @admin, notice: "Admin was successfully created." }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_update_params)
        format.html { redirect_to @admin, notice: "Admin was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1 or /admins/1.json
  def destroy
    # Prevent deleting the admin account
    respond_to do |format|
      format.html { redirect_to admins_path, alert: "Admin account cannot be deleted.", status: :see_other }
      format.json { render json: { error: "Admin account cannot be deleted" }, status: :unprocessable_entity }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through for create.
    def admin_params
      params.expect(admin: [ :username, :password, :password_confirmation, :name, :email ])
    end

    # Parameters for update (cannot change username)
    def admin_update_params
      params.expect(admin: [ :password, :password_confirmation, :name, :email ])
    end
end
