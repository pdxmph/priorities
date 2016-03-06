class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy]


  def set_goal_priority
    @priority = params[:priority]
    @goal = Goal.find(params[:goal])
    @goal.priority = @priority

    if @goal.save
      respond_to do |format|
        format.js { render :action => 'update_priority_button.js.haml',
                           :locals => {:id => @goal.id,
                                       :priority => @goal.priority,
                                       :goal => @goal}}
        format.html 
      end
    end
  end

  def set_goal_support
    @support = params[:support]
    @goal = Goal.find(params[:goal])
    @goal.support = @support

    if @goal.save
      respond_to do |format|
        format.js { render :action => 'update_support_button.js.haml',
                           :locals => {:id => @goal.id,
                                       :support => @goal.support,
                                       :goal => @goal}}
        format.html 
      end
    end
  end

 def set_goal_frequency
    @frequency = params[:frequency]
    @goal = params[:goal]
    @goal.frequency = @frequency

    if @goal.save
      respond_to do |format|
        format.js { render :action => 'update_frequency_button.js.haml',
                           :locals => {:id => params[:goal_id],
                                       :frequency => @goal.frequency,
                                       :goal => @goal}}
        format.html 
      end
    end
 end

  def set_writer_coverage
    @writer_coverage = params[:writer_coverage]
    @goal = params[:goal]
    @goal.writer_coverage = @writer_coverage

    if @goal.save
      respond_to do |format|
        format.js { render :action => 'update_writer_coverage_button.js.haml',
                           :locals => {:id => params[:goal_id],
                                       :writer_coverage => @goal.writer_coverage,
                                       :goal => @goal}}
        format.html 
      end
    end
  end


  
  # GET /goals
  # GET /goals.json
  def index
    @goals = Goal.all
  end

  # GET /goals/1
  # GET /goals/1.json
  def show
  end

  # GET /goals/new
  def new
    @goal = Goal.new
  end

  # GET /goals/1/edit
  def edit
  end

  # POST /goals
  # POST /goals.json
  def create
    @goal = Goal.new(goal_params)
    @team = @goal.team
    respond_to do |format|
      if @goal.save
        format.js {render :action => 'update_goals.js.haml', :object => @team, :locals => {:goals => @team.goals}}
      else
        format.html { render :new }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goals/1
  # PATCH/PUT /goals/1.json
  def update
    respond_to do |format|
      if @goal.update(goal_params)
        format.html { redirect_to @goal, notice: 'Goal was successfully updated.' }
        format.json { render :show, status: :ok, location: @goal }
      else
        format.html { render :edit }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.json
  def destroy
    @goal.destroy
    respond_to do |format|
      format.html { redirect_to goals_url, notice: 'Goal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def goal_params
      params.require(:goal).permit(:name, :description, :team_id, :priority, :support, :effort)
    end
end
