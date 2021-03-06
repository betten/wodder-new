class WodsController < ApplicationController

  before_filter :require_signin, :only => [:new, :create, :edit, :update, :destroy, :up_vote, :save, :unsave, :saved]
  before_filter :require_paid, :only => [:save, :unsave, :saved]

  PAGINATE_PER_PAGE = 15

  def index
    @wods = Wod.ranked_within_past_24h.paginate :page => params[:page], :per_page => PAGINATE_PER_PAGE
  end

  def rss
    @wods = Wod.all.within_past_24h.ordered_by_rank
    render :layout => false
    response.header["Content-Type"] = "application/xml; charset=utf-8"
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
    @wods = GymWod.ranked_within_past_24h.paginate :page => params[:page], :per_page => PAGINATE_PER_PAGE
  end

  def user
    @wods = UserWod.ranked_within_past_24h.paginate :page => params[:page], :per_page => PAGINATE_PER_PAGE
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
    wod.upvote(current_user)
    redirect_to wods_path
  end

  def save
    wod = Wod.find(params[:id])
    unless current_user.has_saved_wod?(wod)
      current_user.saved_wods << wod
      current_user.save
    end
    redirect_to current_user
  end

  def unsave
    wod = Wod.find(params[:id])
    # there's gotta be another way to destroy many-to-many
    # relations using mongoid
    @current_user.saved_wods.delete(wod)
    @current_user.saved_wod_ids.delete(wod.id)
    @current_user.save
    wod.saved_by_ids.delete(@current_user.id)
    wod.save
    redirect_to wods_path
  end

  def saved
  end

end
