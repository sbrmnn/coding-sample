class BankAdmins::Users::GoalsController < BankAdmins::ApplicationController
  
  def index
    @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
    @goals = @user.try(:goals).select(:id, :name, :type, :amount, :completion, :priority)
    record = @user.blank? ? "user not found" : @goal
    status = @user.blank? ? :not_found : :ok
    json_response(record, status)
  end

  def show
    @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
    @goal = @user.try(:goals).find_by(id: params[:id]).select(:id, :name, :type, :amount, :completion, :priority)
    if @goal
      record = @goal
      status = :ok
    else
      record = @user.blank? ? "user not found" : @goal
      status = :not_found
    end
    json_response(record, status)
  end

  def create
    @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
    @goals = @user.try(:goals)
    if @goals
      @goal =  Demographic.new(goal_params)
      @goals << @goal
      record = @goal
      status = @goal.errors.any? ? :unprocessable_entity :  :created
    else
      record = @user.blank? ? "user not found" : @goal
      status = :not_found
    end
    json_response(record, status)
  end

  def update
    @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
    @goal = @user.try(:goals).try{ |obj| obj.find_by(:id=> params[:id])}
    if @goal
      @goal.update_attributes(goal_params) 
      record = @goal
      status = @goal.errors.any? ? :unprocessable_entity :  :ok
    else
      record = @user.blank? ? "user not found" : @goal
      status = :not_found
    end 
    json_response(record, :not_found)
   end

  def destroy
    @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
    @goal = @user.try(:goals).try{ |obj| obj.where(:id=> params[:id]).first }
    if @goal
      @goal.destroy 
      record = @goal
      status = :ok
    else
      record = @user.blank? ? "user not found" : @goal
      status = :not_found
    end
    json_response(record, status) 
   end

   protected

   def goal_params
     params.require(:goal).permit(:name, :type, :amount, :completion, :priority)
   end
end
