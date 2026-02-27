class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :sign_out_blocked_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def authenticate_admin!
    redirect_to root_path, alert: "Access denied. Admins only." unless current_user&.admin?
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    return admin_dashboard_path if resource_or_scope.is_a?(User) && resource_or_scope.admin?

    super
  end

  private

  def sign_out_blocked_user
    return unless user_signed_in? && current_user.blocked?

    sign_out(current_user)
    redirect_to root_path, alert: "Your account has been blocked."
  end
end
