class BankAdmins::UsersController < BankAdmins::ApplicationController
   
   def index
     @users = current_bank_admins_financial_institution.users
     json_response(@users, :ok)
   end

   def create
     @user = User.new(params[:user])
     current_bank_admins_financial_institution.users << @user
     if @user.errors.any?
        json_response(@user, :unprocessable_entity)
        render_unprocessable_entity_response(@user)
     else
        json_response(@user, :created)
     end
   end
end
