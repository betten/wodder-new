class UsersController < ApplicationController

  before_filter :require_signin, :only => [:index, :create, :edit, :update]

  def index
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
    redirect_to current_user_path and return if signed_in? and @current_user.id == @user.id
  end

  def destroy
  end

end
