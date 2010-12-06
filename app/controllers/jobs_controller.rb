class JobsController < ApplicationController

  def update_all
    @gyms = Gym.all
  end

  def update
    gym = Gym.find(params[:id])
    render :nothing => true, :status => gym.check_for_new_wod ? 200 : 500;
  end

  def clear
    Gym.all.each do |gym|
      gym.current_id = nil
      gym.save
    end
  end

end
