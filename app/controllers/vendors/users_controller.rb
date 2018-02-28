class Vendors::UsersController < Vendors::ApplicationController
  
  def index
    @users = current_vendor.users
    json_response(@users)
  end
 
  def show
    @user = current_vendor.users.find_by(token: params[:token])
    third_party_login(@user)
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
end
