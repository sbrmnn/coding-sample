class GoalCompletion
  attr_reader :recurring_days, :algo_rate, :amount_left, :goal_id, :input_frequency, :input_repeats, :input_amount, :input_start_dt, :transfer_happend_today
  
  def initialize(goal_id, frequency=nil, repeats=nil, amount=nil, start_dt=nil)
    validate_inputs(frequency, repeats, amount, start_dt)
    @goal_id = goal_id
    raise "Goal with ID not found" if goal.blank?
    @algo_rate = calculate_algo_rate
    @amount_left = goal_statistic.amount_left.to_f 
    @input_frequency = frequency
    @input_repeats =    repeats
    @input_amount =    amount
    @input_start_dt =  start_dt
    @recurring_days = calculate_recurring_days
    @transfer_happend_today = transfer_happend_today?
  end


  def calculate
    return 0 if amount_left <= 0
    if algo_rate == 0.0
      if recurring_days == 0.0
        return 'unavailable'
      else
         return sanitize_days(recurring_days) 
      end
    elsif recurring_days == 0.0
      return sanitize_days((amount_left/algo_rate).round(1).ceil)  
    end
    algo_transfer_date_count = algo_transfer_dates.count
    if algo_transfer_date_count > max_days
      if ((recurring_transfer_dates.count * recurring_transfer_rule.amount.to_f) + (algo_transfer_date_count*algo_rate))  <= amount_left
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

  def validate_inputs(frequency, repeats, amount, start_dt)
    if (!frequency && repeats && amount && start_dt) || (frequency && !repeats && !amount && !start_dt) || (!repeats && amount && start_dt) || (repeats && !amount && start_dt) || (repeats && amount && !start_dt) 
      raise "Please specify all arguments."
    end
    if frequency.present? && !['day', 'week', 'month'].include?(frequency)
      raise "Valid frequency values are ['day','week','month']" 
    end
  end

  def recurring_start_dt
    recurring_transfer_rule.start_dt.beginning_of_day.to_datetime  
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
    @algo_transfer_dates ||= (start_date..algo_end_date).to_a
  end

  def algo_end_date
    days =  ((amount_left/algo_rate).ceil)
    if days >= max_days
     start_date + max_days.days
    else
      start_date + ((amount_left/algo_rate).ceil).days
    end
  end
  
  def start_date
    if transfer_happend_today
      start_date = today + 1.day
    else
      start_date = today
    end
  end

  def calculate_recurring_days
    return 0.0 if recurring_transfer_rule.blank?
    multiple = (amount_left/recurring_transfer_rule.amount.to_f).ceil
    add_days = ((multiple*recurring_transfer_rule.repeats).send("#{recurring_transfer_rule.frequency.pluralize}"))
    if start_date > recurring_start_dt
      end_date = start_date + add_days
      latest_recurring_transfer_date = ActiveRecord::Base.connection.execute("SELECT generate_series(timestamp '#{recurring_start_dt}', '#{start_date}', '#{recurring_transfer_rule.repeats} #{recurring_transfer_rule.frequency}') :: timestamp").map{|l| l}.map{|l| l["generate_series"].to_datetime}.last
      days = (end_date - (start_date - latest_recurring_transfer_date).days - today).to_i
    else
      latest_recurring_transfer_date = recurring_start_dt + add_days
      days = (latest_recurring_transfer_date - today).to_i
    end
    return days
  end

  def goal
    @goal ||= Goal.find_by(id: goal_id)
  end

  def transfer_happend_today?
    Transfer.where(user: goal.user).where("created_at >= ? and created_at <= ?", today.beginning_of_day,  today.end_of_day).any?
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
    if input_frequency || input_repeats || input_amount || input_start_dt
      @recurring_transfer_rule ||= RecurringTransferRule.new(frequency: input_frequency, repeats: input_repeats, amount: input_amount, start_dt: input_start_dt)
    else
      @recurring_transfer_rule ||= RecurringTransferRule.find_by(goal: goal, deleted_at: nil)
    end
  end
end
