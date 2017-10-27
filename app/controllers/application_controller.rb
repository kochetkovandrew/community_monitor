class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  before_action :configure_permitted_parameters, if: :devise_controller?
#  after_action :verify_authorized, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :email, :password, :password_confirmation, :remember_me, :sign_up_code] )
  end

  def insufficient_permissions
    redirect_to controller: :users, action: :profile, notice: 'Insufficient permissions.'
  end

  def has_permission?(permission_name)
    result = false
    unless current_user.nil?
      current_user.permission_users.each do |permission_user|
        if (permission_user.permission.name == permission_name)
          result = true
        end
      end
    end
    result
  end

  def require_permission!(permission_name)
    if !has_permission?(permission_name)
      insufficient_permissions
    end
  end

end
