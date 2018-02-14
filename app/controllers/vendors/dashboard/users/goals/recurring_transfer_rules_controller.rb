class Vendors::Dashboard::Users::Goals::RecurringTransferRulesController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key
  before_action :find_goal

  def update
    @recurring_transfer_rule = @goal.try(:recurring_transfer_rule)
    if @recurring_transfer_rule
      @recurring_transfer_rule.update_attributes(recurring_transfer_rules_param)
    else
     @recurring_transfer_rule = @goal.build_recurring_transfer_rule(recurring_transfer_rules_param)
     @recurring_transfer_rule.save
    end
    json_response(@recurring_transfer_rule) 
  end


  def show
    @recurring_transfer_rule = @goal.try(:recurring_transfer_rule)
    json_response(@recurring_transfer_rule)
  end

 
  protected

  def find_goal
    @goal = @user.goals.find_by(id: params[:goal_id])
    if @goal.blank? 
      json_response({:goal => :not_found}, nil, :not_found) and return 
    end
  end

  def recurring_transfer_rules_param
    if params[:recurring_transfer_rules].blank?
     {}
    else
     params.require(:recurring_transfer_rules).permit(:amount, :frequency, :repeats, :start_dt, :end_dt)
    end
  end
end
