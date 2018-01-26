class Vendors::Users::SettingsController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key
  
  def show
    @user&.slice(:default_savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :safety_net_active, :max_transfer_amount)
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
     params.require(:user).permit(:default_savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :safety_net_active, :max_transfer_amount)
    end
  end
end
