class Vendors::Users::SettingsController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key
  
  def show
    @settings = @user&.slice(:default_savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :safety_net_active, :max_transfer_amount)
    json_response(@settings)
  end

  def update
    @user.update_attributes(user_params)
    @settings = @user&.slice(:default_savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :safety_net_active, :max_transfer_amount)
    json_response(@settings) 
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
