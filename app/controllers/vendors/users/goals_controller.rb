class Vendors::Users::GoalsController < Vendors::ApplicationController
  before_action :find_user

  def index
    @goals = @user.try(:goals).where(params[:goal])
    json_response(@goals)
  end

  def show
    @goal = @user.try(:goals).find_by(id: params[:id])
    json_response(@goal)
  end

  def create
    @goals = @user.try(:goals)
    @goal =  Goal.new(goal_params)
    @goals << @goal
    json_response(@goal)
  end

  def update
    @goal = @user.try(:goals).try{ |obj| obj.find_by(:id=> params[:id])}
    if @goal
      @goal.update_attributes(goal_params) 
    end 
    json_response(@goal)
   end

  def destroy
    @goal = @user.try(:goals).try{ |obj| obj.find_by(:id=> params[:id]) }
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