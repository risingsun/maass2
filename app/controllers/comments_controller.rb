class CommentsController < ApplicationController

  def create
    @comment = Comment.create(params[:comment])
    if @comment.save
      redirect_to blogs_path
    end
    
  end

end
