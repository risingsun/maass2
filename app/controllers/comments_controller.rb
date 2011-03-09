class CommentsController < ApplicationController

  def create
    @comment = @p.comments.create(params[:comment])
    @comment.save
#    @comment.comment_count()
    redirect_to request.referer
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @comment.comment_count()
    flash[:notice] = "Successfully destroyed blog."
    redirect_to request.referer
  end
  
end