require 'koala'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_project
  before_action :oauth_initialize

  layout :layout_by_resource

  def koala_api(token)
    @graph = Koala::Facebook::API.new(token)
  end

  def oauth_initialize
    if user_signed_in? && @project.blank?
      @oauth ||= Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], ENV['FACEBOOK_CALLBACK'])
    end
  end

  protected

  def set_project
    if user_signed_in?
      @project = Project.find(session[:project_id]) rescue nil
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  end

  def layout_by_resource
    if devise_controller? and user_signed_in?
      'devise'
    else
      'application'
    end
  end
end
