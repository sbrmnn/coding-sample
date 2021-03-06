class MonottoUsers::GoalsController < MonottoUsers::ApplicationController
  
  def index
    @goals = Goal.all.where(params[:goal])
    json_response(@goals)
  end

  def create
    @goal = Goal.create(goal_params)
    json_response(@goal)
  end

  def show
    @goal = Goal.find_by(id: params[:id])
    json_response(@goal)
  end

  def update
    @goal = Goal.find_by(id: params[:id])
    if @goal.present?
      @goal.update_attributes(goal_params)
    end
    json_response(@goal)
  end

  def destroy
   @goal = Goal.find_by(id: params[:id]).try(:destroy)
   json_response(@goal) 
  end

  protected

  def goal_params
    params.require(:goal).permit(:user_id, :tag, :priority, :target_amount, :balance, :xref_goal_name)
  end
end
