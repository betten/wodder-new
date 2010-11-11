class JobsController < ApplicationController

  def update
    Gym.all.each do |gym|
      gym.check_for_new_wod
    end
  end

  def clear
    Gym.all.each do |gym|
      gym.current_id = nil
      gym.save
    end
  end

end
