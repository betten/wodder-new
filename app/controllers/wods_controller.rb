class WodsController < ApplicationController

  before_filter :require_signin, :only => [:new, :create, :edit, :update, :destroy, :up_vote]

  def index
    @wods = Wod.all_by_rank 
  end

  def show
    @wod = Wod.find(params[:id])
  end

  def new
    @wod = UserWod.new
  end

  def create
    @wod = UserWod.new(params[:user_wod])
    @wod.user = @current_user
    if @wod.save
      # probably want to flash wod successfully created
      redirect_to current_user_path
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
  end

  def gym
  end

  def user
  end

  def destroy
  end

  def up_vote
    wod = Wod.find(params[:id])
    unless wod.has_point_from_user?(current_user) and !current_user.is_admin?
      wod.points = wod.points + 1;
      wod.points_from << current_user.id.to_s
      wod.save
    end
    redirect_to wods_path # should probably redirect :back or to referrer
  end

end
