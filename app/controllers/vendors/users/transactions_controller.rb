class Vendors::Users::TransactionsController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_public_key
  
  def index
    @transactions = @user.transactions.order('date DESC').limit(15)
    json_response(@transactions)
  end
end
