class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :description, :email, :password, :password_confirmation, :current_password, :google_uid, :provider)}
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :description, :email, :password, :password_confirmation, :current_password, :google_uid, :provider)}
  end
  
  protect_from_forgery with: :exception
end
