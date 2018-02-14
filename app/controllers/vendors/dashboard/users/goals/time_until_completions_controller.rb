class Vendors::Dashboard::Users::Goals::TimeUntilCompletionsController < ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key
  before_action :find_goal
  
  def show
    time_until_completion = TimeUntilCompletion.where(goal: @goal).first
    recurring_transfers_rate = time_until_completion_params[:amount].to_f/(time_until_completion_params[:repeats]*frequency_to_days(time_until_completion_params[:frequency])).to_f rescue 0
    algo_rate = time_until_completion.amount.to_f/time_until_completion.avg_amount.to_f rescue 0
    total_rate = algo_rate + recurring_transfers_rate
    return json_response({:time_until_completion => 'unavailable'}, nil, :ok) and return  if total_rate == 0
    json_response({:time_until_completion => time_until_completion.amount/total_rate}, nil, :ok)   
  end


  
  private 


  def time_until_completion_params
     if params[:time_until_completion].blank?
       {}
     else
       params.require(:time_until_completion).permit(:frequency, :repeats, :amount)
     end
  end

  def frequency_to_days(frequency)
  	case frequency
  	when 'days'
  		1
  	when 'weeks'
  		7
  	when 'months'
  		30
  	end
  end
end
