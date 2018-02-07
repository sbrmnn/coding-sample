class Vendors::Dashboard::UsersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key
  
  def show
  	third_party_login(@user)
    json_response(@user)
  end
end
