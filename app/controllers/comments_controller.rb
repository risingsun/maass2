class CommentsController < ApplicationController

  def create
    @comment = Comment.create(params[:comment])
    if @comment.save
      blog = Blog.find(params[:comment][:commentable_id])
      c = blog[:comments_count]
      c = c + 1
      blog.update_attributes(:comments_count => c )
    end
    redirect_to blogs_path
    
  end

end
