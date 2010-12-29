class UsersController < ApplicationController

  before_filter :require_signin, :only => [:me, :edit, :update]
  before_filter :verify_donation, :only => [:donate]


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
    @current_user.email = params[:user][:email]
    if params[:password].present? or params[:password_confirmation].present?
      @current_user.password = params[:password]
      @current_user.password_confirmation = params[:password_confirmation]
    end
    if @current_user.save
      redirect_to current_user_path
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
    redirect_to current_user_path and return if current_user? and @current_user.is?(@user)
    @wod = @user.wods.most_recent if @user.has_wods? 
  end

  def destroy
  end

  def donate
    flash[:donated] = true
    if current_user
      current_user.paid = true
      current_user.save
      redirect_to current_user
    else
      session[:donated] = true
      redirect_to signup_users_path
    end
  end

  private

  def verify_donation
    [:tx, :st, :amt, :cc, :sig].each do |param|
      redirect_to wods_path and return false unless params[param].present?
    end
  end


end
