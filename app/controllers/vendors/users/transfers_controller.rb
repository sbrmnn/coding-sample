class Vendors::Users::TransfersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key

  def index
    @transfers = @user.transfers.order(created_at: :desc).where(status: :successful).limit(15)
    json_response(@transfers)
  end
end
