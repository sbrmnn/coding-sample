class Vendors::Users::SessionsController < ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key
  
  def show
  	json_response(@user)
  end
end
