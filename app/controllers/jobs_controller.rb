class JobsController < ApplicationController

  before_filter :require_admin#, :unless => :call_from_self? # using a rake task to call cron jobs

  def update_all
    @gyms = Gym.all.approved
  end

  def update
    @gym = Gym.find(params[:id])
    @status = @gym.check_for_new_wod
    render :json => @status and return if request.xhr?
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
