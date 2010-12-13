class GymsController < ApplicationController

  before_filter :require_admin, :only => [:new, :create, :update, :test_xpath]

  def index
    @gyms = Gym.all
  end

  def show
    @gym = Gym.find(params[:id])
  end

  def new
    @gym = Gym.new
  end

  def create
    @gym = Gym.new(params[:gym])
    if @gym.save
      redirect_to @gym
    else
      render :new
    end
  end

  def edit
    @gym = Gym.find(params[:id])
  end

  def update
    @gym = Gym.find(params[:id])
    if @gym.update_attributes(params[:gym])
      redirect_to @gym
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

end
