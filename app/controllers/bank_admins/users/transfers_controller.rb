class BankAdmins::Users::TransfersController < ApplicationController
  def index
     @transfers = current_bank_admin.users.transfers
     json_response(@transfers, :ok)
   end

   def create
     @user_transfers = current_bank_admin.users.where(:id=> params[:id]).first.try(:transfers)
     if @user_transfers
        @transfer =  Transfer.new(transfer_params)
        @user_transfers <<@transfer
        status = @transfer.errors.any? :unprocessable_entity :  :created
        json_response(@transfer, status)
     else
        json_response(@user_transfers, :not_found)
     end
   end

   def update
     @user = current_bank_admin.users.where(:id=> params[:id]).first
     if @user
       @user.update_attributes(user_params) 
       status = :ok
     else
       status = :not_found
     end 
     json_response(@user, status)
   end

   protected

   def transfer_params
     params.require(:demographic).permit(:key, :value)
   end
	
end
