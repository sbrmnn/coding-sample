class GoalCompletion
  attr_reader :recurring_days, :algo_rate, :amount_left, :goal_id, :input_frequency, :input_repeats, :input_amount, :input_start_dt
  
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
  end


  def calculate
    return 0 if amount_left <= 0
    if algo_rate == 0.0
      if recurring_days == nil
         return 'unavailable'
      else
         return sanitize_days(recurring_days) 
      end
    elsif recurring_days == nil
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
    i = ArrayIterator.new(algo_transfer_dates)
    (algo_transfer_dates.count).times do
      ad = i.item
      if recurring_transfer_dates.include?(ad)
        total = total + recurring_transfer_rule.amount.to_f + algo_rate
      else
        total = total + algo_rate
      end
      new_end_date = ad
      if total >= amount_left    
       break
      end
      i.next_item
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
    if transfer_happened_today?
       today + 1.day
    else
       today
    end
  end

  def calculate_recurring_days
    return nil if recurring_transfer_rule.blank?
    if recurring_transfer_rule.repeats == 0 && recurring_transfer_rule.amount.to_f >= amount_left
      if recurring_transfer_rule.start_dt.beginning_of_day.to_datetime > today
        return (recurring_transfer_rule.start_dt.beginning_of_day.to_datetime - today).to_i
      elsif recurring_transfer_rule.start_dt.beginning_of_day.to_datetime == today && !transfer_happened_today?
        return 0
      else
        return nil
      end
    elsif recurring_transfer_rule.repeats == 0 && recurring_transfer_rule.amount.to_f < amount_left
      return nil 
    end
    multiple = (amount_left/recurring_transfer_rule.amount.to_f).ceil
    if today > recurring_start_dt
      add_days = ((multiple*recurring_transfer_rule.repeats).send("#{recurring_transfer_rule.frequency.pluralize}"))
      end_date = today + add_days
      latest_recurring_transfer_date = ActiveRecord::Base.connection.execute("SELECT generate_series(timestamp '#{recurring_start_dt}', '#{today}', '#{recurring_transfer_rule.repeats} #{recurring_transfer_rule.frequency}') :: timestamp").map{|l| l}.map{|l| l["generate_series"].to_datetime}.last
      if transfer_happened_today? && latest_recurring_transfer_date == today
        unless transfer_happened_today?
          multiple = multiple - 1
        end
        add_days = ((multiple*recurring_transfer_rule.repeats).send("#{recurring_transfer_rule.frequency.pluralize}"))
        latest_recurring_transfer_date = latest_recurring_transfer_date + add_days
        days = (latest_recurring_transfer_date - today).to_i
      elsif latest_recurring_transfer_date == today
        unless transfer_happened_today?
          multiple = multiple - 1
        end
        add_days = ((multiple*recurring_transfer_rule.repeats).send("#{recurring_transfer_rule.frequency.pluralize}"))
        latest_recurring_transfer_date = today + add_days
        days = (latest_recurring_transfer_date - today).to_i
      else
        days = (end_date - (today - latest_recurring_transfer_date).days - today).to_i 
      end
    elsif today == recurring_start_dt
      unless transfer_happened_today?
        multiple = multiple - 1
      end
      add_days = ((multiple*recurring_transfer_rule.repeats).send("#{recurring_transfer_rule.frequency.pluralize}"))
      latest_recurring_transfer_date = recurring_start_dt + add_days
      days = (latest_recurring_transfer_date - today).to_i
    else
      multiple = multiple - 1
      add_days = ((multiple*recurring_transfer_rule.repeats).send("#{recurring_transfer_rule.frequency.pluralize}"))
      latest_recurring_transfer_date = recurring_start_dt + add_days
      days = (latest_recurring_transfer_date - today).to_i
    end
    days
  end

  def goal
    @goal ||= Goal.find_by(id: goal_id)
  end

  def transfer_happened_today?
    if @tr.nil? && recurring_transfer_rule.try(:id).present?
     @tr = Transfer.where(user: goal.user, rule_id: recurring_transfer_rule.id).where("created_at >= ? and created_at <= ?", today.beginning_of_day,  today.end_of_day).any?
    else
      @tr
    end
  end

  def calculate_algo_rate
    rate = time_until_completion.avg_amount.to_f/time_until_completion.avg_days.to_f rescue 0.0
    rate = 0.0 if rate.infinite? || rate.nan? 
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
