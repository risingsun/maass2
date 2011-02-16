class UsersController < Devise::RegistrationsController

  def update
    @profile =  current_user.profile || current_user.build_profile
    @notification =@profile.notification || @profile.build_notification
    @permission =@profile.permission || @profile.build_permission

      if resource.update_with_password(params[:user])
        set_flash_message :notice, :updated
        #      sign_in resource_name, resource, :bypass => true
        redirect_to edit_profile_path(current_user)
      else
        clean_up_passwords(current_user)
        render "profiles/edit_account"
      end
  end

end
