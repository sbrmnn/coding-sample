class Vendors::Dashboard::Users::TransfersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key

  def index
    @transfers = @user.transfers.order(id: :desc).where(status: :successful).where.not(amount: nil).limit(15)
    json_response(@transfers)
  end
end
