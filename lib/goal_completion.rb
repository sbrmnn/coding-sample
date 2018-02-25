class GoalCompletion
  attr_reader :recurring_rate, :algo_rate, :amount_left, :goal_id, :input_frequency, :input_repeats, :input_amount
  
  def initialize(goal_id, frequency=nil, repeats=nil, amount=nil)
    validate_inputs(frequency, repeats, amount)
    @goal_id = goal_id
    raise "Goal with ID not found" if goal.blank?
    @algo_rate = calculate_algo_rate
    @amount_left = goal_statistic.amount_left.to_f 
    @input_frequency = frequency
    @input_repeats =    repeats
    @input_amount =    amount
    @recurring_rate = calculate_recurring_rate
  end


  def calculate
    return 0 if amount_left <= 0
    if algo_rate == 0.0
      if recurring_rate == 0.0
        return 'unavailable'
      else
         return sanitize_days((amount_left/recurring_rate).ceil) 
      end
    elsif recurring_rate == 0.0
      return sanitize_days((amount_left/algo_rate).ceil)  
    end
    if recurring_transfer_rule.frequency == 'day' && recurring_transfer_rule.repeats == 1
      return sanitize_days((amount_left/(algo_rate + recurring_rate)).ceil) 
    end
    if algo_transfer_dates.count > max_days
      if (recurring_transfer_dates.count * recurring_transfer_rule.amount.to_f) < amount_left
        return sanitize_days(max_days)
      end
    end
    new_end_date = algo_end_date
    total = 0
    i = 0
    (algo_transfer_dates.count).times do
      ad = algo_transfer_dates[i]
      if recurring_transfer_dates.include?(ad)
        total = total + recurring_transfer_rule.amount.to_f + algo_rate
      else
        total = total + algo_rate
      end
      new_end_date = ad
      if total >= amount_left    
       break
      end
      i = i + 1
    end
    return sanitize_days((new_end_date - today).to_i)  
  end

  private

  def validate_inputs(frequency, repeats, amount)
   if (!frequency && repeats && amount) || (frequency && !repeats && !amount) || (!repeats && amount) || (repeats && !amount)
      raise "Please specify all arguments."
   end
   if frequency.present? && !['day', 'week', 'month'].include?(frequency)
     raise "Valid frequency values are ['day','week','month']" 
   end
  end

  def recurring_start_dt
    recurring_transfer_rule.start_dt.beginning_of_day   
  end

  def today
    Date.today.beginning_of_day.to_datetime
  end

  def recurring_transfer_dates
    return @recurring_transfer_dates if @recurring_transfer_dates.present?
    if recurring_transfer_rule.repeats == 0
      return @recurring_transfer_dates ||= [recurring_start_dt].to_set &  algo_transfer_dates
    else
     @recurring_transfer_dates ||= ActiveRecord::Base.connection.execute("SELECT generate_series(timestamp '#{recurring_start_dt}', '#{algo_end_date}', '#{recurring_transfer_rule.repeats} #{recurring_transfer_rule.frequency}') :: timestamp").map{|l| l[
        "generate_series"].to_date}.to_set & algo_transfer_dates
    end
  end

  def algo_transfer_dates
    @algo_transfer_dates ||=  (today..algo_end_date).to_a
  end

  def algo_end_date
    days =  ((amount_left/algo_rate).ceil)
    if days >= max_days
     today + max_days.days
    else
      today + ((amount_left/algo_rate).ceil).days
    end
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

  def sanitize_days(days)
   if max_days < days
     max_days
   else
    days
   end
  end



  def max_days
    MAX_TIME_UNTIL_COMPLETION
  end

  def goal_statistic
    @goal_statistic ||= GoalStatistic.find_by(goal: goal)
  end

  def time_until_completion
    @time_until_completion ||=  TimeUntilCompletion.find_by(goal: goal)
  end

  def recurring_transfer_rule
    if input_frequency || input_repeats || input_amount
      @recurring_transfer_rule ||= RecurringTransferRule.new(frequency: input_frequency, repeats: input_repeats, amount: input_amount)
    else
      @recurring_transfer_rule ||= RecurringTransferRule.find_by(goal: goal)
    end
  end
end