class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "wodder"

  before_filter :set_current_user

  def require_signin
    unless current_user
      flash[:must_be_signed_in] = true
      redirect_to signup_users_path 
    end
  end

  def current_user
    return nil unless current_user?
    @current_user
  end

  def current_user?
    !!@current_user
  end

  def require_admin
    #redirect_to wods_path unless current_user and current_user.is_admin?
    return true
  end

  private

  def set_current_user
    @current_user = User.find(session[:current_user_id]) if session[:current_user_id].present?
  end

end
