class BankAdmins::UsersController < BankAdmins::ApplicationController
   
   def index
     @users = current_bank_admin.users
     json_response(@users, :ok)
   end

   def create
     @user = User.new(user_params)
     current_bank_admin.financial_institution.users << @user
     if @user.errors.any?
        status = :unprocessable_entity
     else
        status = :created
     end
     json_response(@user, :created)
   end

   def update
     @user = current_bank_admin.users.find_by(:bank_identifier=> params[:bank_identifier])
     if @user
       @user.update_attributes(user_params) 
       status = :ok
     else
       status = :not_found
     end 
     json_response(@user, status)
   end

   def destroy
     @user = current_bank_admin.users.find_by(:bank_identifier=> params[:bank_identifier])
     if @user
       @user.destroy
       status = :ok
     else
      status = :not_found
     end
     json_response(@user, status)
   end

   protected
   
   def user_params
     params.require(:user).permit(:sequence, :bank_identifier, :savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :safety_net_active, :max_transfer_amount)
   end
end
