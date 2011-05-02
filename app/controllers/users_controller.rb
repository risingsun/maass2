class UsersController < Devise::RegistrationsController

  def update
    @profile =  @p
    if resource.update_with_password(params[:user])
      set_flash_message :notice, :updated
    else
      clean_up_passwords(current_user)
      flash[:error] = "Password invalid/blank"
    end
    redirect_to edit_account_profile_path(@profile)
  end

end