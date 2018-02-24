class GoalCompletion
  attr_reader :recurring_rate, :algo_rate, :amount_left, :goal_id
  
  def initialize(goal_id)
    @goal_id = goal_id
    raise "Goal with ID not found" if goal.blank?
    @algo_rate = calculate_algo_rate
    @amount_left = goal_statistic.amount_left.to_f
    @recurring_rate = calculate_recurring_rate  
  end


  def calculate
    return 0 if amount_left <= 0
    if algo_rate == 0.0
      if recurring_rate == 0.0
        return 'unavailable'
      else
         return (amount_left/recurring_rate).ceil
      end
    elsif recurring_rate == 0.0
      return (amount_left/algo_rate).ceil
    end
    
    if recurring_transfer_rule.frequency == 'day' && recurring_transfer_rule.repeats == 1
      return (amount_left/(algo_rate + recurring_rate)).ceil
    end
    new_end_date = algo_end_date
    total = 0
    i = 0
    (algo_transfer_dates.count-1).times do
      ad = algo_transfer_dates[i]
      if recurring_transfer_dates.include?(ad)
        total = total + recurring_transfer_rule.amount.to_f + algo_rate
      else
        total = total + algo_rate
      end
      new_end_date = ad.to_datetime
      if total >= amount_left
       break
      end
      i = i + 1
    end
    return (new_end_date - Date.today).to_f
  end

  private

  def recurring_start_dt
    recurring_transfer_rule.start_dt.beginning_of_day   
  end

  def today
    Date.today.beginning_of_day
  end

  def recurring_transfer_dates
    return @recurring_transfer_dates if @recurring_transfer_dates.present?
    if recurring_transfer_rule.repeats == 0
      return @recurring_transfer_dates ||= [recurring_start_dt].to_set &  algo_transfer_dates
    else
     @recurring_transfer_dates ||= ActiveRecord::Base.connection.execute("SELECT generate_series(date '#{recurring_start_dt}', '#{algo_end_date}', '#{recurring_transfer_rule.repeats} #{recurring_transfer_rule.frequency}') :: date").map{|l| l[
        "generate_series"].to_date}.to_set & algo_transfer_dates
    end
  end

  def algo_transfer_dates
    @algo_transfer_dates ||=  (today.to_date..algo_end_date.to_date).to_a
  end

  def algo_end_date
    today + ((amount_left/algo_rate).ceil).days
  end

  def calculate_recurring_rate
    return 0.0 if recurring_transfer_rule.blank?
    multiple = (amount_left/recurring_transfer_rule.amount.to_f).ceil
    days = Date.today+((multiple*recurring_transfer_rule.repeats).send("#{recurring_transfer_rule.frequency.pluralize}")) - Date.today
    (amount_left.to_f/days.to_f) rescue 0.0
  end

  def goal
    @goal ||= Goal.find_by(id: goal_id)
  end

  def calculate_algo_rate
    rate = time_until_completion.avg_amount.to_f/time_until_completion.avg_days.to_f rescue 0.0
    rate = 0.0 if rate.infinite? 
    rate
  end

  def goal_statistic
    @goal_statistic ||= GoalStatistic.find_by(goal: goal)
  end

  def time_until_completion
    @time_until_completion ||=  TimeUntilCompletion.find_by(goal: goal)
  end

  def recurring_transfer_rule
    @recurring_transfer_rule ||= RecurringTransferRule.find_by(goal: goal)
  end
end