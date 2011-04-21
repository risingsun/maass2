class ForumTopicsController < ApplicationController

  before_filter :load_forum, :except => [:new, :create]

  layout "plain"

  def new
    @forum = Forum.find(params[:forum_id])
    @forum_topic = @forum.topics.new
  end

  def create
    @forum = Forum.find(params[:forum_id])
    @forum_topic = @forum.topics.build(params[:forum_topic])
    if @forum_topic.save
      flash[:notice] = "Successfully Created ForumTopic."
    else
      flash[:error] = "ForumTopic Was Not Successfully Created."
    end
    redirect_to forum_path(@forum)
  end

  def show
  end

  def edit
  end

  def update
    @forum_topic.attributes = params[:forum_topic]
    if @forum_topic.save
      flash[:notice] = "Successfully Updated ForumTopic."
    else
      flash[:error] = "ForumTopic Was Not Successfully Updated."
    end
    redirect_to forum_path(@forum)
  end

  def destroy
    @forum_topic.destroy
    flash[:notice] = "Successfully Deleted ForumTopic."
    redirect_to forum_path(@forum)
  end

  private

  def allow_to
    super :admin, :all => true
    super :active_user, :only => [:new, :create, :show]
  end

  def load_forum
    @forum = Forum.find(params[:forum_id])
    @forum_topic = @forum.topics.find(params[:id])
  end

end