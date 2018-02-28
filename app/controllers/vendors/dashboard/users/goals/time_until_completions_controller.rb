class Vendors::Dashboard::Users::Goals::TimeUntilCompletionsController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_user_key
  before_action :find_goal
  
  def show
    if days_to_completion == 'unavailable'
      json_response({:time_until_completion => 'unavailable'}, nil, :ok) and return
    end
    json_response({:time_until_completion => print_time_until_completion(days_to_completion)}, nil, :ok)
  end

  private 

  def days_to_completion 
    if params[:calculate].to_b
      start_dt = time_until_completion_params[:start_dt] || Date.today
      GoalCompletion.new(@goal.id, time_until_completion_params[:frequency], time_until_completion_params[:repeats], time_until_completion_params[:amount].to_f, start_dt).calculate
    else
      GoalCompletion.new(@goal.id).calculate
    end
  end 
 

  def time_until_completion_params
     if params[:time_until_completion].blank?
       {}
     else
       params.require(:time_until_completion).permit(:frequency, :repeats, :amount, :delete_at, :start_dt)
     end
  end
end
