class Vendors::UsersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login, only: [:show, :update]
  before_action :find_user_by_vendor_key, only: [:show, :update]
  
  def index
    @users = current_vendor.users
    json_response(@users)
  end
  
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
     params.require(:user).permit(:bank_user_id, :default_savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :safety_net_active, :max_transfer_amount)
   end
  end
end
