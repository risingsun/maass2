class CommentsController < ApplicationController

  def create
    @comment = Comment.create(params[:comment])
    @comment.save
#    blog = Blog.find(params[:comment][:commentable_id])
##   c = Comment.find(:all,:conditions => { :commentable_id => params[:comment][:commentable_id] }).count
#    c = blog[:comments_count]
#    c = c + 1
#    blog.update_attributes(:comments_count => c )
    redirect_to blogs_path
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to blogs_path
    flash[:notice] = "Successfully destroyed blog."
  end

  def comment_count
    blog = Blog.find(params[:comment][:commentable_id])
    c = Comment.find(:all,:conditions => { :commentable_id => params[:comment][:commentable_id] }).count
    c = blog[:comments_count]
    c = c + 1
    blog.update_attributes(:comments_count => c )
    c = blog[:comments_count]
    c = c + 1
    blog.update_attributes(:comments_count => c )
  end
end
