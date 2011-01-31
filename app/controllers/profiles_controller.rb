class ProfilesController < ApplicationController

  def create
    @profile =  current_user.profile || current_user.build_profile
    @educations = @profile.educations || @profile.educations.build
    @works = @profile.works || @profile.works.build
    if @profile.save
      flash[:notice] = "Profile created."
      redirect_to :edit
    else
      render 'edit'
    end
  end

  def edit
    @profile =  current_user.profile || current_user.build_profile
    @educations = @profile.educations || @profile.educations.build
    @works = @profile.works || @profile.works.build
    @marker = @profile.marker || @profile.build_marker
 end

  def update
    @profile = current_user.profile
    if @profile.update_attributes!(params[:profile])
      flash[:notice] = "Profile updated."
      redirect_to :edit
    else
      flash[:notice] = "ERROR"
      render 'edit'
    end
  end

end