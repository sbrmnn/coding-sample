class BankAdmins::UsersController < BankAdmins::ApplicationController
   
   def index
     @users = current_bank_admin.users.where(user_params)
     json_response(@users, :ok)
   end

   def create
     @user = User.new(user_params)
     current_bank_admin.financial_institution.users << @user
     status = @user.errors.any? ? :unprocessable_entity : :created
     json_response(@user, status)
   end

   def show
     @user = current_bank_admin.users.find_by(bank_user_id:  params[:bank_user_id])
     if @user
       status = :ok
     else
       status = :not_found
     end
     json_response(@user, status)
  end

   def update
     @user = current_bank_admin.users.find_by(bank_user_id: params[:bank_user_id])
     if @user
       @user.update_attributes(user_params) 
       status = @user.errors.any? ? :unprocessable_entity :  :ok
     else
       status = :not_found
     end 
     json_response(@user, status)
   end

   def destroy
     @user = current_bank_admin.users.find_by(bank_user_id: params[:bank_user_id])
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
    if params[:user].nil?
      {}
    else
      params.require(:user).permit(:sequence, :bank_user_id, :savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :safety_net_active, :max_transfer_amount)
    end
   end
end
