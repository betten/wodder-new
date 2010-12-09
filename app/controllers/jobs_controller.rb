class JobsController < ApplicationController

  before_filter :require_admin

  def update_all
    @gyms = Gym.all
  end

  def update
    gym = Gym.find(params[:id])
    status = gym.check_for_new_wod
    render :json => status
  end

  def clear_all
    Gym.all.each do |gym|
      gym.current_id = nil
      gym.save
    end
  end

  def clear
    gym = Gym.find(params[:id])
    gym.current_id = nil
    gym.save
    render :clear_all
  end

end
