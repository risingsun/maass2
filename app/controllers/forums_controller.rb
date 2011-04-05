class ForumsController < ApplicationController

  before_filter :hide_side_panels

  layout "plain"

  def index
    @forum =  Forum.new
    @forums = Forum.find(:all)
  end
  
  def show
    @forum = Forum.find(params[:id])
  end

  def new
    @forum = Forum.new
  end
  
  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      flash[:notice] = "Successfully Created Forum."
      redirect_to forums_path
    else
      render :action => 'new'
    end
  end

  def edit
    @forum = Forum.find(params[:id])
  end

  def update
    @forum = Forum.find(params[:id])
    @forum.attributes = params[:forum]
    if @forum.save
      flash[:notice] = "Successfully Updated Forum."
      redirect_to forums_path
    else
      flash[:error]= "Forum Was Not Successfully Updated."
      render 'new'
    end
  end
  
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    flash[:notice] = "Successfully Destroyed Forum."
    redirect_to forums_path
  end

  private

  def hide_side_panels
    if !current_user
      redirect_to new_user_session_path()
    end
    @hide_panels = true
  end
  
end
