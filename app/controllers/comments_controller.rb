class CommentsController < ApplicationController

  def create
    @comment = Comment.create(params[:comment])
    @comment.save
    @comment.comment_count()
    redirect_to profile_blogs_path(@p)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @comment.comment_count()
    redirect_to profile_blogs_path(@p)
    flash[:notice] = "Successfully destroyed blog."
  end
  
end