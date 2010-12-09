class GymsController < ApplicationController
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

  def update
  end

  def test_xpath
    page = Hpricot(open(params[:url]))
    x = page.at(params[:xpath])
    render :text => x.to_html
  end

end
