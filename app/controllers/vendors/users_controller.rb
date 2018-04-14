class Vendors::UsersController < Vendors::ApplicationController
  
  def index
    @users = current_vendor.users
    json_response(@users)
  end

  def create
    @user = VendorUserBuilder.new(current_vendor.id, user_params).build
    @user.save
    json_response(@user)
  end

  protected

  def user_params
    if params[:user].blank?
      {}
    else
      params.require(:user).permit(:bank_user_id, :default_savings_account_identifier, :checking_account_identifier,
                                   :transfers_active, :max_transfer_amount, :financial_institution_name)
    end
  end
end
