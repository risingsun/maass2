class CommentsController < ApplicationController

  before_filter :load_profile, :only=>[:index]

  def index    
    @comments = Comment.between_profiles(@p, @profile).paginate(:page => @page, :per_page => @per_page)
    redirect_to @p and return if @p == @profile
  end

  def create
    @comment = @p.comments.create(params[:comment])
    if @comment.save
      if @comment.commentable_type == "Blog"
        @blog = Blog.find(params[:comment][:commentable_id])
        @profile = @blog.profile
        ArNotifier.delay.comment_send_on_blog(@comment,@profile,@p) if @profile.wants_email_notification?("blog_comment")
        @blog.commented_users(@p.id).each do |comment|
          ArNotifier.delay.comment_send_on_blog_to_others(@comment,comment.profile,@p,@blog.profile) if comment.profile.wants_email_notification?("blog_comment")
        end
      elsif @comment.commentable_type == "Profile"
        @profile= Profile.find(@comment.commentable_id)
        ArNotifier.delay.comment_send_on_profile(@comment,@profile,@p) if @profile.wants_email_notification?("profile_comment")
      end
      flash[:notice] = "Comment created successfully."
      redirect_to request.referer
    else
      flash[:notice] = "Comment not created successfully."
      redirect_to request.referer
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed blog."
    redirect_to request.referer
  end

  private

  def allow_to
    super :active_user, :only => [:index, :create,:destroy]
  end

  def load_profile        
    @profile = params[:profile_id] == @p ? @p : Profile.find(params[:profile_id])
  end
  
end