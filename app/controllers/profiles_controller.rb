class ProfilesController < ApplicationController

  before_filter :load_profile, :only => [:create,:edit,:update,:show,:edit_account,:search]
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
    render :partial=>'result'
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
