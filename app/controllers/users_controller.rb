class UsersController < ApplicationController
  def signup
    if request.post?
      u = User.new(
        :email => params[:email],
        :password => params[:password],
        :password_confirmation => params[:password_confirmation])
      if u.save
        session[:user] = u
        redirect_to '/users/home'
      else
        flash[:errors] = u.errors
    end
  end

  def signin
    if request.post?
      u = User.authenticate(params[:email], params[:password])
      if u.nil?
        flash[:errors] = 'invalid email password combo'
      else
        session[:user] = u
        redirect_to '/users/home'
      end
    end
  end

  def signout
    session[:user] = nil
  end

  def view
  end

  def home
  end

end
