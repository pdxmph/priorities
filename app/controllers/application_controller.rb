class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?


  def page_not_found
    @title = "Page Not Found"
    @url ? @url = request.referer : @url = nil
    render :template => "application/page_not_found", :locals => {:url => @url}   
  end
  
  def docs
    @title = "Docs"
  end
  
  def index
    @title = "Home"
    require 'socket'
    @hostname = request.host_with_port
    
    render :template => "application/index", :locals => {:hostname => @hostname}
  end
  
  def my_flags
    @pages = current_user.get_up_voted Page
  end

  def page_params
    params.require(:page).permit(:title, :tag_list => [])
  end

  def indexed_words
    @tags = Page.tag_counts_on(:indexes)
  end
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)  { |u| u.permit(:jira_name, :fullname, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update)  { |u| u.permit(:jira_name, :fullname, :email, :password, :current_password, :password_confirmation) }
  end
  
end
