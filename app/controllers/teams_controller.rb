class TeamsController < ApplicationController

  def index
    @title = "Teams"
    @teams = Team.order(name: :asc)
  end

  def show
    @team = Team.find(params[:id])
    @title = @team.name
  end

  def new
    @team = Team.new
  end


  def create
    @team = Team.new(:name => params[:team][:name],
                            :user_id => current_user.id
                           )
    if @team.save
      respond_to do |format|
        format.html {redirect_to teams_path, :alert => "Team saved."}
      end
    end
  end


    
  

end
