class Vendors::Dashboard::UsersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key
  
  def show
    BankJoy.user_login(@user.id) if @user.try(:id).present? && @user.bankjoy_user?
    json_response(@user)
  end
end
