class Vendors::UsersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login, if: -> { vendor_key_exists? && show_action? }
  before_action :find_user_by_vendor_key,   if: -> { vendor_key_exists? && show_action? }
  def index
    @users = current_vendor.users
    json_response(@users)
  end
 
  def show
    if current_vendor
      @user = current_vendor.users.find_by(token: params[:token])
    end
    BankJoy.user_login(@user.id) if @user.try(:id).present?
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
