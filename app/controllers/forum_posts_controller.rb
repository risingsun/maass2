class ForumPostsController < ApplicationController

  before_filter :load_forum_post

  def new
    @post = @topic.posts.new
  end

  def create
    @post = @topic.posts.build(params[:post])
    @post.save
    redirect_to forum_path(@forum)
  end

  def edit
    @post = @topic.posts.find(params[:id])
  end

  def destroy
    
  end

  private

  def load_forum_post
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:forum_topic_id])
  end

end
