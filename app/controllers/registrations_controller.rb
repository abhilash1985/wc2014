# app/controllers/registrations_controller.rb

class RegistrationsController < Devise::RegistrationsController
  # before_filter :update_sanitized_params, if: :devise_controller?

  before_filter :configure_permitted_parameters
 
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  # def update
    # # For Rails 4
    # account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # # For Rails 3
    # # account_update_params = params[:user]
# 
    # # required for settings form to submit when password is left blank
    # if account_update_params[:password].blank?
      # account_update_params.delete("password")
      # account_update_params.delete("password_confirmation")
    # end
# 
    # @user = User.find(current_user.id)
    # if @user.update_attributes(account_update_params)
      # set_flash_message :notice, :updated
      # # Sign in the user bypassing validation in case their password changed
      # sign_in @user, :bypass => true
      # redirect_to after_update_path_for(@user)
    # else
      # render "edit"
    # end
  # end
 
  protected
 
  # my custom fields are :name, :heard_how
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name,
        :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name,
        :email, :password, :password_confirmation, :current_password)
    end
  end
end