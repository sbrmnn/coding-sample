class Vendors::FinancialInstitutions::UsersController < Vendors::ApplicationController
   
   def create
     @user = User.where(checking_account_identifier: params[:checking_account_identifier], financial_institution_id: @financial_institution.id).first_or_create do |user|
              user.default_savings_account_identifier = params[:default_savings_account_identifier]
              user.token = params[:token]
             end
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
