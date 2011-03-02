class HomesController < ApplicationController

  def index
    @users = User.all - [current_user]
  end

  def show
    if !current_user.blank?
      @user = User.find(params[:id])
      @profile = @user.profile
      @works = @profile.works
      @polls = @profile.polls
      @educations = @profile.educations
    else
      redirect_to homes_path
      flash[:notice] = "It looks like you don't have permission to view that page."
    end
  end

  def polls
    @user = User.find(params[:id])
    @profile = @user.profile
    @polls = @profile.polls.order("created_at desc").paginate(:page => params[:page],:per_page => 10)
    render :template => 'homes/_poll_link'
  end

  def admin
    @profile = @p
  end

end