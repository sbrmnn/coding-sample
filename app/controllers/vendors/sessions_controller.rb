class Vendors::SessionsController < Vendors::ApplicationController
  skip_before_action :require_vendor_login, only: [:create], raise: false

  def create
    get_auth_token(Vendor)
  end

  def destroy
    current_vendor.invalidate_token
    head :ok
  end
end
