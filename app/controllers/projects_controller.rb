class ProjectsController < ApplicationController
  before_filter :verify_is_admin, except: [:show, :index]

  def show
    @project = Project.friendly.find(params[:id])
    @versions = @project.versions.order(version_number: :desc)
    @title = @project.display_name
  end

  def index
    @title = "Projects"
    @projects = Project.order(display_name: :asc)

  end

  def edit
    @project = Project.friendly.find(params[:id])
    @title = "Edit #{@project.display_name}"
  end

  def update
    @project = Project.friendly.find(params[:id])
    if @project.update_attributes(project_params)
      redirect_to projects_path
    else
      render 'edit', alert: "Bad value in your edit form. Better talk to Mike."
    end
  end

  private
  def project_params
    params.require(:project).permit(:display_name, :name, :versioned, :description, :web_path)
  end

  def verify_is_admin
    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
  end

  
end
