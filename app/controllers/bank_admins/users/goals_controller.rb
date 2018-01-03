class BankAdmins::Users::GoalsController < BankAdmins::ApplicationController
  before_action :find_user

  def index
    @goals = @user.goals.where(goal_params)
    json_response(@goals)
  end

  def show
    @goal = @user.goals.find_by(id: params[:id])
    json_response(@goal)
  end

  def create
    @goals = @user.goals
    @goal =  Goal.new(goal_params)
    @goals << @goal
    json_response(@goal)
  end

  def update
    @goal = @user.goals.find_by(:id=> params[:id])
    if @goal
      @goal.update_attributes(goal_params) 
    end 
    json_response(@goal)
   end

  def destroy
    @goal = @user.goals.find_by(:id=> params[:id])
    if @goal
      @goal.destroy 
    end
    json_response(@goal) 
   end

   protected

   def goal_params
     if params[:goal].blank?
       {}
     else
       params.require(:goal).permit(:tag, :priority, :target_amount, :balance, :xref_goal_name)
     end
   end
end
