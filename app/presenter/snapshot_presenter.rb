class SnapshotPresenter
  def initialize(financial_institution_id)
    @financial_institution = FinancialInstitution.find(financial_institution_id)
    @average_user_balance  = @financial_institution.goals.average(:balance) || 0
    @sum_balance           = @financial_institution.transfers.where(status: :successful).sum(:amount)
    @sum_message_clicks    = @financial_institution.messages.sum(:clicks)
    @total_messages        = @financial_institution.messages.count
    @total_users           = @financial_institution.users.count
    @total_num_of_goals    = @financial_institution.goals.count
    @last_seven_days_user_signup     = @financial_institution.users.where("created_at>'#{7.days.ago}'").count
    @total_amount_of_completed_goals = GoalStatistic.where(goal_id: @financial_institution.goals.pluck(:id)).where("percent_saved >= 100").count
  end
  
  def summary
    {
     "financial_institution_id"        => @financial_institution.id,
     "average_user_balance"            => @average_user_balance,
     "sum_balance"                     => @sum_balance,
     "sum_message_clicks"              => @sum_message_clicks,
     "total_messages"                  => @total_messages,
     "total_num_of_goals"              => @total_num_of_goals,
     "total_users"                     => @total_users,
     "last_seven_days_user_signup"     => @last_seven_days_user_signup,
     "total_amount_of_completed_goals" => @total_amount_of_completed_goals,
     "historical_snapshot_stats"       => [historical_snapshot_stat.as_json]
    }
  end

  def archive
    @snapshot_summary = self.summary
    ss_keys = @snapshot_summary.keys
    hs_keys = HistoricalSnapshot.new.attributes.keys
    diff_key = ss_keys - hs_keys
    diff_key.each do |key_to_delete|
      @snapshot_summary.delete(key_to_delete)
    end
    HistoricalSnapshot.new(@snapshot_summary).save
  end

  def historical_snapshot_stat
    HistoricalSnapshotStat.find_by(financial_institution_id: @financial_institution.id) || {"financial_institution_id"=>@financial_institution.id, "thirty_day_savings"=> 0}
  end

end