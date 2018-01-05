class Vendors::Users::TransfersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_public_key

  def index
    @transfers = @user.transfers.order(end_date: :desc).where(status: 'successful').limit(15)
    json_response(@transfers)
  end
end
