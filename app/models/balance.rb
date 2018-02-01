class Balance
  
  def initialize(user_id)
    @amount = calculate_savings_balance(user_id)
  end

  def amount 
  	@amount
  end
  
  private

  def calculate_savings_balance(user_id)
    goals = Goal.where(user_id: user_id).order(priority: :asc)
    sum_balance_of_goals = goals.sum(:balance)
    savings_acct_balance = goals.pluck(:savings_account_identifier, :savings_acct_balance).uniq.map{|r| r[1]}.sum
  end
end
