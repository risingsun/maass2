class ProfilesController < ApplicationController

  before_filter :load_profile, :only => [:create,:edit,:update,:edit_account]
  before_filter :search_results, :only => [:search]

  def create
    if @profile.save
      flash[:notice] = "Profile created."
    else
      flash[:notice] = "Failed creation."
    end

    render 'edit'
  end

  def edit
  end

  def update
    case params[:commit]
    when "Update Permissions"
      @profile.update_attributes(params[:profile])
      redirect_to edit_account_profile_path(current_user.profile)
    when "Set Default"
      @profile.update_attributes(params[:profile])
      @profile.permissions.each {|p| p.destroy}
      redirect_to edit_account_profile_path(current_user.profile)
    when "Update Notification"
      NotificationControl.set_value(params[:profile][:notification_control_attributes])
      @profile.update_attributes(params[:profile])
      redirect_to edit_account_profile_path(current_user.profile)
    when "add following"
      @profile.start_following(params[:id])
      redirect_to profile_path(Profile.find(params[:id]).user)
    when "stop follow"
      @profile.stop_following(params[:id])
      redirect_to profile_path(Profile.find(params[:id]).user)
    when "make friend"
      @profile.make_friend(params[:id])
      redirect_to profile_path(Profile.find(params[:id]).user)
    else
      @profile.update_attributes params[:profile]
      flash[:notice] = "Profile updated."
      redirect_to :edit
    end
  end

  def destroy

  end

  def show
    if !current_user.blank?
      @profile = Profile.find(params[:id])
      @user = @profile.user
      @educations = @profile.educations
      @works = @profile.works
    else
      redirect_to homes_path
      flash[:notice] = "It looks like you don't have permission to view that page."
    end
  end

  def edit_account
    #debugger
    @permissions = @profile.permissions || @profile.permissions.build
    @notification = @profile.notification_control || @profile.build_notification_control
  end

  def search
    if params[:profile][:search_by] && params[:profile][:search_by]== "blog"
      @blogs= Blog.search params["profile"]["search_value"], :match_mode=> :boolean
      @title = "Search"
      render :template => "blogs/search_blog"
    else
      @title = "Search"
      render :template=>'shared/user_friends'
    end
  end

  private

  def load_profile
    @profile =  current_user.profile || current_user.build_profile
    @profile.save
    @profile =  current_user.profile
    @educations = @profile.educations || @profile.educations.build
    @works = @profile.works || @profile.works.build
    @user=current_user
  end

end