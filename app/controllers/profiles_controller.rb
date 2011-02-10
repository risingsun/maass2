class ProfilesController < ApplicationController

  before_filter :load_profile, :only => [:create,:edit]

  def create
    if @profile.save
      flash[:notice] = "Profile created."
      redirect_to :edit
    else
      render 'edit'
    end
  end


  def edit
    @profile =  current_user.profile || current_user.build_profile
    @profile.save
    @educations = @profile.educations || @profile.educations.build
    @works = @profile.works || @profile.works.build
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

  def show
    p "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    p @profile=current_user.profile
    @user=current_user
    @works=@profile.works
    @educations=@profile.educations
  end
  
  private

  def load_profile
    @profile =  current_user.profile || current_user.build_profile
    @educations = @profile.educations || @profile.educations.build
    @works = @profile.works || @profile.works.build
  end

end
