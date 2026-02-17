class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_volunteer, :volunteer_signed_in?, :current_admin, :admin_signed_in?

  private

  def current_volunteer
    return unless session[:volunteer_id]
    @current_volunteer ||= Volunteer.find_by(id: session[:volunteer_id])
  end

  def volunteer_signed_in?
    current_volunteer.present?
  end

  def current_admin
    return unless session[:admin_id]
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  def admin_signed_in?
    current_admin.present?
  end

  def require_volunteer_login
    unless volunteer_signed_in?
      redirect_to login_path, alert: "Please log in"
    end
  end

  def require_admin_login
    unless admin_signed_in?
      redirect_to root_path, alert: "Admin access required"
    end
  end

  def require_same_volunteer!(volunteer)
    unless volunteer_signed_in? && current_volunteer == volunteer
      redirect_to root_path, alert: "Access denied"
    end
  end
end
