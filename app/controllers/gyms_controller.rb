class GymsController < ApplicationController

  before_filter :require_signin, :only => [:new, :create]
  before_filter :require_admin, :only => [:add, :update, :test_xpath, :admin]

  def index
    @gyms = Gym.all.approved.descending(:created_at)
  end

  def show
    @gym = Gym.find(params[:id])
    redirect_to gyms_path unless @gym.approved?
  end

  def add
    @gym = Gym.new
  end

  def new
    @gym = Gym.new
  end

  def create
    @gym = Gym.new(params[:gym])
    @gym.approved = false unless current_user.is_admin? # force approved to false for non admin
    @gym.created_by = @current_user
    if @gym.save
      redirect_to @gym and return if current_user.is_admin?
      flash[:created] = true
      redirect_to new_gym_path
    else
      render :add and return if current_user.is_admin?
      render :new
    end
  end

  def edit
    @gym = Gym.find(params[:id])
  end

  def update
    @gym = Gym.find(params[:id])
    if @gym.update_attributes(params[:gym])
      redirect_to admin_gyms_path
    else
      render :edit
    end
  end

  def test_xpath
    begin
      page = Hpricot(open(params[:url]))
      x = page.at(params[:xpath])
      render :text => x.to_html
    rescue
      render :text => "problems testing - verify that url / xpath are correct"
    end
  end

  def admin
    @gyms = Gym.all
  end

end
