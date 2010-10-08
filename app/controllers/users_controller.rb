class UsersController < ApplicationController
  def signup
    if request.post?
      u = User.new(
        :email => params[:email],
        :password => params[:password],
        :password_confirmation => params[:password_confirmation])
      if u.save
        # set session
        # redirect_to user home
      else
        flash[:errors] = u.errors
        # redirect_to signup
    end
  end

  def signin
  end

  def signout
  end

  def view
  end

end
