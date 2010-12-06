class WodsController < ApplicationController

  before_filter :require_signin, :only => [:new, :create, :edit, :update, :destroy]

  def index
   @wods = Wod.all_by_rank 
  end

  def show
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

end
