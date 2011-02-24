class UsersController < Devise::RegistrationsController

  def create
    super
    @profile=Profile.create(params[:profile].merge(:user_id => resource.id))
  end

  def update
    @profile =  current_user.profile
    @permission =@profile.permissions || @profile.permissions.build
    if resource.update_with_password(params[:user])
      set_flash_message :notice, :updated
      redirect_to edit_account_profile_path(current_user)
    else
      clean_up_passwords(current_user)
      #debugger
      render "profiles/edit_account" 
    end
  end

end
