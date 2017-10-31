class BankAdmins::Users::GoalsController < BankAdmins::ApplicationController
  before_action :find_user

  def index
    @goals = @user.try(:goals).where(params[:goal])
    json_response(@goals)
  end

  def show
    @goal = @user.try(:goals).find_by(id: params[:id])
    if @goal
      status = :ok
    else
      status = :not_found
    end
    json_response(@goal)
  end

  def create
    @goals = @user.try(:goals)
    @goal =  Goal.new(goal_params)
    @goals << @goal
    status = @goal.errors.any? ? :unprocessable_entity :  :created
    json_response(@goal)
  end

  def update
    @goal = @user.try(:goals).try{ |obj| obj.find_by(:id=> params[:id])}
    if @goal
      @goal.update_attributes(goal_params) 
      status = @goal.errors.any? ? :unprocessable_entity :  :ok
    else
      status = :not_found
    end 
    json_response(@goal)
   end

  def destroy
    @goal = @user.try(:goals).try{ |obj| obj.find_by(:id=> params[:id]) }
    if @goal
      @goal.destroy 
      status = :ok
    else
      status = :not_found
    end
    json_response(@goal) 
   end

   protected

   def goal_params
     if params[:goal].blank?
       {}
     else
       params.require(:goal).permit(:name, :amount, :completion, :priority, :tag)
     end
   end
end
