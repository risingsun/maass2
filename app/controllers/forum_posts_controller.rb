class ForumPostsController < ApplicationController

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

  def allow_to
    super :admin, :all => true
    super :active_user, :only => [:new, :create, :destroy]
  end

  def load_forum_post
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:forum_topic_id])
  end

end