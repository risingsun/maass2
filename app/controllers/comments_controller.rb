class CommentsController < ApplicationController

  def create
    @comment = Comment.create(params[:comment])
    @comment.save
    Blog.comment_count(params[:comment][:commentable_id])
    redirect_to blogs_path
  end

  def destroy
    @comment = Comment.find(params[:id])
    id = Comment.find(params[:id]).commentable_id
    @comment.destroy
    Blog.comment_count(id)
    redirect_to blogs_path
    flash[:notice] = "Successfully destroyed blog."
  end
  
end