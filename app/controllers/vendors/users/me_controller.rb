class Vendors::Users::MeController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key
  
  def show
  	json_response(@user)
  end

  def update
  	@user.update_attributes(user_params)
  	json_response(@user) 
  end


  protected

  def user_params
   if params[:user].blank?
    {}
   else
    params.require(:user).permit(:checking_account_identifier, :default_savings_account_identifier, :transfers_active, :safety_net_active)
   end
  end
end
