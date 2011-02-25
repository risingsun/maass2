class ProfilesController < ApplicationController

  before_filter :load_profile, :only => [:create,:edit,:update,:show,:edit_account]
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
      Profile.start_following(current_user.profile.id, params[:id])
      redirect_to home_path(Profile.find(params[:id]).user)
    when "stop follow"
      Profile.stop_following(current_user.profile.id, params[:id])
      redirect_to home_path(Profile.find(params[:id]).user)
    when "make friend"
      Profile.make_friend(params[:id], current_user.profile.id)
      redirect_to home_path(Profile.find(params[:id]).user)
    else
      @profile.update_attributes params[:profile]
      flash[:notice] = "Profile updated."
      redirect_to :edit
    end
  end

  def show
  end
 
  def edit_account
    @permissions = @profile.permissions || @profile.permissions.build
    @notification = @profile.notification_control || @profile.build_notification_control
  end

  def search
    if params[:profile][:search_by] && params[:profile][:search_by]== "blog"
      @blogs= Blog.search params["profile"]["search_value"], :match_mode=> :boolean
      render :template => "blogs/search_blog"
    else
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