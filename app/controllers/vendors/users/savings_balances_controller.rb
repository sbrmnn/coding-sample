class Vendors::Users::SavingsBalancesController < ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_public_key

  def show
    records = @user.goals.pluck(:savings_account_identifier, :savings_acct_balance).uniq
    @savings_balance = {savings_balance: records.map{|r| r[1]}.sum}
    json_response(@savings_balance)
  end
end
