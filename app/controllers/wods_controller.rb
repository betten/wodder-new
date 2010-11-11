class WodsController < ApplicationController
  def all
   @wods = Wod.all 
  end

  def gym
  end

  def user
  end

  def new
  end

end
