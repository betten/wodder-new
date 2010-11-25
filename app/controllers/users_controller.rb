class UsersController < ApplicationController

  before_filter :require_signin, :only => [:index, :edit, :update]

  def index
    @user = User.find(session[:user_id])
  end

  def signup
    @user = User.new
  end

  def signin
    @user = User.authenticate(params[:email], params[:password])
    if @user
      session[:current_user_id] = @user.id
      redirect_to users_path
    else
      flash[:signin_notice] = 'invalid email password combo'
      redirect_to :back
    end
  end

  def signout
    @current_user = session[:current_user_id] = nil
    redirect_to root_url
  end

  def create
    @user = User.new(params[:user])
    if @user.save
    debugger
      session[:user_id] = @user.id
      redirect_to users_path
    else
      render :action => "signup"
    end
  end

  def wods
  end

  def edit
  end

  def update
  end

  def show
    @user = User.find(params[:id])
    redirect_to users_path and return if session[:user_id].present? and session[:user_id] == params[:id]
  end

  def destroy
  end

  private

  def require_signin
    unless signed_in?
      redirect_to root_url
    end
  end

end
