class Vendors::Users::BalancesController < ApplicationController
  def show
    records = @user.goals.pluck(:savings_account_identifier, :savings_acct_balance).uniq
    @savings_balance = {savings_balance: records.map{|r| r[1]}.sum}
    json_response(@savings_balance)
  end
end
