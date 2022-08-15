class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :site_authenticate

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  protected

  def configure_permitted_parameters
    [:first_name, :last_name, :address, :email, :zip_code].each do |param|
      devise_parameter_sanitizer.for(:sign_up) << param
      devise_parameter_sanitizer.for(:account_update) << param
    end
  end

  def require_basic_auth?
    ENV['BASIC_AUTH_PW'].present?
  end

  def site_authenticate
    if require_basic_auth?
      authenticate_or_request_with_http_basic do |username, password|
        username == 'heatseek' && password == ENV["BASIC_AUTH_PW"]
      end
    end
  end
end
