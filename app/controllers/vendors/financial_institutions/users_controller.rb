class Vendors::FinancialInstitutions::UsersController < Vendors::ApplicationController
   
   def create
     @user = User.new(user_params)
     current_vendor.financial_institutions.find(params[:financial_institution_id]).users << @user
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
