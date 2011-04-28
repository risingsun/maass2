class UsersController < Devise::RegistrationsController

#  include Devise
#
#  def create
#    build_resource
#    if resource.save
#      @profile=Profile.create(params[:profile].merge(:user => resource))
#      if resource.active?
#        set_flash_message :notice, :signed_up
#        sign_in_and_redirect(resource_name, resource)
#      else
#        #set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s
#        flash[:notice] = resource.inactive_message.to_s
#        #expire_session_data_after_sign_in!
#        redirect_to after_inactive_sign_up_path_for(resource)
#      end
#    else
#      clean_up_passwords(resource)
#      render_with_scope :new
#    end
#  end

  def update
    @profile =  current_user.profile
    @permission =@profile.permissions || @profile.permissions.build
    if resource.update_with_password(params[:user])
      set_flash_message :notice, :updated
      redirect_to edit_account_profile_path(current_user)
    else
      clean_up_passwords(current_user)
      render "profiles/edit_account"
    end
  end

#  protected
#
#  # The path used after sign up. You need to overwrite this method
#  # in your own RegistrationsController.
#  def after_sign_up_path_for(resource)
#    after_sign_in_path_for(resource)
#  end
#
#  # Overwrite redirect_for_sign_in so it takes uses after_sign_up_path_for.
#  def redirect_location(scope, resource) #:nodoc:
#    stored_location_for(scope) || after_sign_up_path_for(resource)
#  end
#
#  # The path used after sign up for inactive accounts. You need to overwrite
#  # this method in your own RegistrationsController.
#  def after_inactive_sign_up_path_for(resource)
#    root_path
#  end
#
#  # The default url to be used after updating a resource. You need to overwrite
#  # this method in your own RegistrationsController.
#  def after_update_path_for(resource)
#    if defined?(super)
#      ActiveSupport::Deprecation.warn "Defining after_update_path_for in ApplicationController " <<
#        "is deprecated. Please add a RegistrationsController to your application and define it there."
#      super
#    else
#      after_sign_in_path_for(resource)
#    end
#  end
#
#  # Authenticates the current scope and gets a copy of the current resource.
#  # We need to use a copy because we don't want actions like update changing
#  # the current user in place.
#  def authenticate_scope!
#    send(:"authenticate_#{resource_name}!", true)
#    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
#  end
  
end