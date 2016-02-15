class ReposController < ApplicationController

  def show
    @repo = Repo.find(params[:id])
    @title = "Recent activity for #{@repo.name}"
    @recent_git = @repo.recent_git
    render :template => "repos/show", :locals => {:repo => @repo}
  end

end
