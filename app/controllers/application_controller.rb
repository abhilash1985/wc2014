class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  # protect_from_forgery with: :null_session
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  # rescue_from Pundit::NotAuthorizedError, with: :authorize_admin
  
  def authorize_admin
    unless current_user.is_admin
      flash[:error] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
  end
  
  def can_see_predictions?(end_time, time_zone)
    end_time.in_time_zone(time_zone) < Time.now.in_time_zone(time_zone)
  end
end
