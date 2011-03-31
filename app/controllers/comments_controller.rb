class CommentsController < ApplicationController

  def create    
    @comment = @p.comments.create(params[:comment])
    if @comment.save
      if @comment.commentable_type == "Blog"
        @blog = Blog.find(params[:comment][:commentable_id])
        @profile = @blog.profile
        ArNotifier.comment_send_on_blog(@comment,@profile,@p).deliver if @profile.wants_email_notification?("blog_comment")
      elsif @comment.commentable_type == "Profile"
        @profile= Profile.find(@comment.commentable_id)
        ArNotifier.comment_send_on_profile(@comment,@profile,@p).deliver if @profile.wants_email_notification?("profile_comment")
      end
      flash[:notice] = "Comment was created successfully."
      redirect_to request.referer
    else
      flash[:notice] = "Comment was not created successfully"
      redirect_to request.referer
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed blog."
    redirect_to request.referer
  end
  
end