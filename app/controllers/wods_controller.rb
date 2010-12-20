class WodsController < ApplicationController

  before_filter :require_signin, :only => [:new, :create, :edit, :update, :destroy, :up_vote, :save, :saved]
 # before_filter :require_paid, :only => [:save, :saved]

  def index
    @wods = Wod.all_by_rank 
  end

  def show
    @wod = Wod.find(params[:id])
    @comment = Comment.new
  end

  def new
    @wod = UserWod.new
  end

  def create
    @wod = UserWod.new(params[:user_wod])
    @wod.user = current_user
    if @wod.save
      # probably want to flash wod successfully created
      redirect_to current_user_path
    else
      render :action => "new"
    end
  end

  def edit
    @wod = UserWod.find(params[:id])
  end

  def update
    @wod = UserWod.find(params[:id])
    if @wod.update_attributes(params[:user_wod])
      redirect_to current_user_path
    else
      render :edit
    end
  end

  def gym
    @wods = GymWod.all_by_rank
  end

  def user
    @wods = UserWod.all_by_rank
  end

  def destroy
    wod = Wod.find(params[:id])
    if current_user.is?(wod.user)
      wod.destroy
    end
    flash[:wod_deleted] = true
    redirect_to current_user
  end

  def up_vote
    wod = Wod.find(params[:id])
    unless wod.has_point_from_user?(current_user) and !current_user.is_admin?
      wod.points = wod.points + 1;
      wod.points_from << current_user.id.to_s
      wod.save
    end
    redirect_to :back
  end

  def save
    wod = Wod.find(params[:id])
    unless current_user.has_saved_wod?(wod)
      current_user.saved_wods << wod
      current_user.save
    end
    #redirect_to :back
  end

  def saved
    # DRY up the check for save action above
  end

end
