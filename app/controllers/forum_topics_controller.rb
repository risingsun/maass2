class ForumTopicsController < ApplicationController

  before_filter :hide_side_panels
  before_filter :load_forum, :except => [:new, :create]

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
  end

  def edit
  end

  def update
    @forum_topic.attributes = params[:forum_topic]
    @forum_topic.save
    redirect_to forum_path(@forum)
  end

  def destroy
    @forum_topic.destroy
    redirect_to forum_path(@forum)
  end

  private

  def hide_side_panels
    @hide_panels = true
  end

  def load_forum
    @forum = Forum.find(params[:forum_id])
    @forum_topic = @forum.topics.find(params[:id])
  end

end
