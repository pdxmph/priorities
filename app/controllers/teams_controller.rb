class TeamsController < ApplicationController

  def index
    @title = "Teams"
    @teams = Team.order(name: :asc)
  end

  def show
    @team = Team.find(params[:id])
    @title = @team.name
  end
end
