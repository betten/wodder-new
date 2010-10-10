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
        flash[:signup_errors] = u.errors
      end
    end
  end

  def signin
    if request.post?
      u = User.authenticate(params[:email], params[:password])
      if u.nil?
        flash[:signin_errors] = 'invalid email password combo'
        redirect_to :back
      else
        session[:user] = u
        redirect_to '/users/home'
      end
    end
  end

  def signout
    session[:user] = nil
    redirect_to '/wods/all'
  end

  def view
  end

  def home
  end

end
