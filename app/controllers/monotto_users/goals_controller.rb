class MonottoUsers::GoalsController < MonottoUsers::ApplicationController
	  def index
    @goals = Goal.all.where(params[:goal])
    if @goals.present?
      status = :ok
    else
      status = :not_found
    end
    json_response(@goals, status)
  end

  def create
    @goal = Goal.create(goal_params)
    if @goal.errors.any?
      status = :unprocessable_entity
    else
      status = :created
    end
    json_response(@goal, status)
  end

  def show
    @goal = Goal.find_by(id: params[:id])
    if @goal
      status = :ok
    else
      status = :not_found
    end
    json_response(@goal, status)
  end

  def update
    @goal = Goal.find_by(id: params[:id])
    if @goal.present?
      @goal.update_attributes(goal_params)
      status = @goal.errors.any? ? :unprocessable_entity : :ok
    else
      status = :not_found
    end
    json_response(@goal, status)
  end

  def destroy
   @goal = Goal.find_by(id: params[:id]).try(:destroy)
   if @goal.present?
     status = :ok
   else
     status = :not_found
   end
   json_response(@goal, status) 
  end

  protected

  def goal_params
    params.require(:goal).permit(:name, :amount, :completion, :priority, :user_id)
  end
end
