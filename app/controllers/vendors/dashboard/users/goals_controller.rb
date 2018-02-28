class Vendors::Dashboard::Users::GoalsController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_user_key
  
  def index
    @goals = @user.goals.order(priority: :asc)
    json_response(@goals, included_models)
  end

  def show
    @goal = @user.goals.find_by(id: params[:id])
    json_response(@goal, included_models)
  end

  def create
    @goals = @user.goals
    @goal =  Goal.new(goal_params)
    @goals << @goal
    json_response(@goal, included_models)
  end

  def update
    @goal = @user.goals.find_by(:id=> params[:id])
    if @goal
      @goal.update_attributes(goal_params) 
    end 
    json_response(@goal, included_models)
  end

  def destroy
    @goal = @user.goals.find_by(:id=> params[:id])
    if @goal
      @goal.destroy 
    end
    json_response(@goal, included_models)
   end

   protected

   def goal_params
     if params[:goal].blank?
       {}
     else
       params.require(:goal).permit(:tag, :priority, :target_amount, :xref_goal_name)
     end
   end

   private

   def included_models
    [:xref_goal_type, :recurring_transfer_rule]
   end
end
