class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def index
    @title = "Home"

    if user_signed_in?
      @lists = current_user.lists
      @other_lists = current_user.other_lists
    end

    render :template => "application/index"

  end

  def docs
    @title = "Documentation"
    render :template => "application/docs"
  end
  
  
    protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)  { |u| u.permit(:jira_name, :last_name, :first_name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update)  { |u| u.permit(:last_name, :first_name, :email, :password, :current_password, :password_confirmation) }
  end


end
