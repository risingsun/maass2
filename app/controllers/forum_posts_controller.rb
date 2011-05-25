class ForumPostsController < ApplicationController
  
  skip_authorization_check
  
  before_filter :load_forum_post

  layout "plain"

  def new
    @post = @topic.posts.new
  end

  def create    
    @post = @topic.posts.build(params[:post])
    if @post.save
      flash[:notice] = "Successfully Created ForumPost."
    else
      flash[:error] = "ForumPost Was Not Successfully Created."
    end
    redirect_to :back
  end

  def destroy
    @post = @topic.posts.find(params[:id])
    @post.destroy
    flash[:notice] = "Successfully Deleted ForumPost."
    redirect_to :back
  end

  private

  def load_forum_post
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:forum_topic_id])
  end

end