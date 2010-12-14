class UsersController < ApplicationController

  before_filter :require_signin, :only => [:me, :edit, :update]

  def index
    @users = User.all
  end

  def me
  end

  def signup
    @user = User.new
  end

  def signin
    @user = User.authenticate(params[:email], params[:password])
    if @user
      session[:current_user_id] = @user.id
      redirect_to current_user_path
    else
      flash[:signin_error] = true
      redirect_to signup_users_path
    end
  end

  def signout
    @current_user = session[:current_user_id] = nil
    redirect_to root_url
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @current_user = @user
      session[:current_user_id] = @user.id
      redirect_to current_user_path
    else
      render :action => "signup"
    end
  end

  def wods
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
  end

  def show
    @user = User.find(params[:id])
    redirect_to current_user_path and return if current_user? and @current_user.is?(@user)
  end

  def destroy
  end

end
