class Vendors::FinancialInstitutions::UsersController < Vendors::ApplicationController
   skip_before_action :require_vendor_login
   before_action :find_financial_institution_by_vendor_key
   
   def create
     @user = User.where(checking_account_identifier: user_params[:checking_account_identifier], financial_institution_id: @financial_institution.id).first_or_create do |user|
               user.default_savings_account_identifier = user_params[:default_savings_account_identifier]
               user.token = user_params[:token]
               user.bank_user_id = user_params[:bank_user_id]
               user.max_transfer_amount = user_params[:max_transfer_amount]
             end
     @error = {error: "Please select another checking account."} if (@user.token != user_params[:token])
     # If another user with the same checking account id within a vendor tries to signup,
     # we want to block them from logging in and state that they need to choose a different checking account.
     # Users differ from each other by the token value; hence, the reason why are checking
     # to make sure the token passed in matches with the existing record existing record.
     @error.present? ? json_response(@error, nil, :bad_request) : json_response(@user)
   end
   
   protected
   
   def user_params
    if params[:user].blank?
      {}
    else
      params.require(:user).permit(:bank_user_id, :default_savings_account_identifier, :checking_account_identifier,
                                   :transfers_active, :safety_net_active, :max_transfer_amount, :token)
    end
   end
end
