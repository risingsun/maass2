class ForumTopicsController < ApplicationController

  before_filter :hide_side_panels

  def index
    @forum = Forum.find(params[:id])
    @forum_topics = @forum.forum_topics
  end

  def new
    @forum = Forum.find(params[:forum_id])
    @forum_topic = @forum.forum_topics.new
  end

  def create
    @forum = Forum.find(params[:forum_id])
    @forum_topic = @forum.forum_topics.build(params[:forum_topic])
    @forum_topic.save
    redirect_to forums_path()
  end

  def destroy
    @forum_topic.destroy
   redirect_ro forums_path
  end
  private

  def hide_side_panels
    @hide_panels = true
  end

end
