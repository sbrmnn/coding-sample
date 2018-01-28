class Vendors::UsersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login, only: [:show], if: :vendor_key_exists?
  before_action :find_user_by_vendor_key,   only: [:show], if: :vendor_key_exists?
 
  def index
    @users = current_vendor.users
    json_response(@users)
  end
 
  def show
   if current_vendor
     @user = current_vendor.users.find_by(token: params[:token])
   end
   json_response(@user)
  end

  def update
    @user = current_vendor.users.find_by(token: params[:token])
    json_response(@user) 
  end

  protected

  def user_params
   if params[:user].blank?
     {}
   else
     params.require(:user).permit(:bank_user_id, :default_savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :safety_net_active, :max_transfer_amount, :financial_institution_id)
   end
  end

  def vendor_key_exists?
    params[:vendor_key].present?
  end
end
