class CommentsController < ApplicationController

  def create
    @comment = @p.comments.create(params[:comment])
    @comment.save
    flash[:notice] = "Successfully created blog."
    redirect_to request.referer
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed blog."
    redirect_to request.referer
  end
  
end