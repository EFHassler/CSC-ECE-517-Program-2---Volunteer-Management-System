class SessionsController < ApplicationController
  def new
    # Show the login form
  end

  def create
    # Handle login - check volunteer first (most common), then admin
    username = params[:username]
    password = params[:password]

    # First, check if it's a volunteer
    volunteer = Volunteer.find_by(username: username)
    if volunteer && volunteer.authenticate(password)
      session[:volunteer_id] = volunteer.id
      redirect_to volunteer, notice: "Logged in successfully as volunteer."
      return
    end

    # If not volunteer, check if it's the admin (preconfigured username "admin")
    admin = Admin.find_by(username: "admin")
    if admin && admin.authenticate(password)
      session[:admin_id] = admin.id
      redirect_to admin_path, notice: "Logged in successfully as admin."
      return
    end

    # If neither matched, show error
    flash.now[:alert] = "Invalid username or password."
    render :new
  end

  def destroy
    # Handle logout - clear session
    session[:volunteer_id] = nil
    session[:admin_id] = nil
    redirect_to login_path, notice: "Logged out successfully."
  end
end
