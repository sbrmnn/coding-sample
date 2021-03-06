class BankAdmins::UsersController < BankAdmins::ApplicationController
   
   def index
     @users = current_bank_admin.users.where(user_params)
     json_response(@users)
   end

   def create
     @user = User.new(user_params)
     current_bank_admin.financial_institution.users << @user
     json_response(@user)
   end

   def show
     @user = current_bank_admin.users.find_by(bank_user_id:  params[:bank_user_id])
     json_response(@user)
  end

   def update
     @user = current_bank_admin.users.find_by(bank_user_id: params[:bank_user_id])
     if @user
       @user.update_attributes(user_params) 
     end 
     json_response(@user)
   end

   def destroy
     @user = current_bank_admin.users.find_by(bank_user_id: params[:bank_user_id])
     if @user
       @user.destroy
     end
     json_response(@user)
   end

   protected
   
   def user_params
    if params[:user].blank?
      {}
    else
      params.require(:user).permit(:bank_user_id, :default_savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :max_transfer_amount)
    end
   end
end
