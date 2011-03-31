class ForumTopicsController < ApplicationController

  before_filter :hide_side_panels

  def index
    @forum = Forum.find(params[:id])
    @forum_topics = @forum.topics
  end

  def new
    @forum = Forum.find(params[:forum_id])
    @forum_topic = @forum.topics.new
  end

  def create
    @forum = Forum.find(params[:forum_id])
    @forum_topic = @forum.topics.build(params[:forum_topic])
    @forum_topic.save
    redirect_to forum_path(@forum)
  end

  def show
    @forum = Forum.find(params[:forum_id])
    @forum_topic = params[:id] ? @forum.topics.find(params[:id]) : @forum.topics.build
  end

  def destroy
    @forum_topic.destroy
    redirect_to forums_path
  end
  private

  def hide_side_panels
    @hide_panels = true
  end

end
