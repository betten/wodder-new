class CommentsController < ApplicationController
  before_filter :require_signin

  def create
    @comment = Comment.new(params[:comment])
    @wod = Wod.find(params[:wod_id])
    @wod.comments << @comment
    @comment.user = current_user
    if @comment.save
      redirect_to wod_path(@wod)
    else
      render "wods/show"
    end
  end

  def destroy
    wod = Wod.find(params[:wod_id])
    comment = wod.find(params[:id])
    return nil unless comment.user.id == current_user.id
    comment.destroy
  end

end
