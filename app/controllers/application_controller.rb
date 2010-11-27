class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "wodder"

  before_filter :set_current_user

  def signed_in?
    !!@current_user
  end

  def require_signin
    unless signed_in?
      redirect_to root_url
    end
  end

  private

  def set_current_user
    @current_user = User.find(session[:current_user_id]) if session[:current_user_id].present?
  end
end
