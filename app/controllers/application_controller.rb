class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "wodder"

  before_filter :set_current_user

  private

  def set_current_user
    @current_user = User.find(session[:user_id]) if session[:user_id].present?
  end
end
