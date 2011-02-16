class ProfilesController < ApplicationController

  before_filter :load_profile, :only => [:create,:edit,:update,:show,:edit_account]

  def create
    if @profile.save
      flash[:notice] = "Profile created."
      redirect_to :edit
    else
      flash[:notice] = "Failed creation."
      render 'edit'
    end
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
  end

  private

  def load_profile
    @profile =  current_user.profile || current_user.build_profile
     @profile.save
    @educations = @profile.educations || @profile.educations.build
    @works = @profile.works || @profile.works.build
    @user=current_user
  end

end
