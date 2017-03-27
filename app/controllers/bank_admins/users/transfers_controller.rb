class BankAdmins::Users::TransfersController < BankAdmins::ApplicationController
   
   def index
     @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
     @transfers = @user.try(:transfers).select(:id, :key, :value)
     record = @user.blank? ? "user not found" : @transfers
     status = @user.blank? ? :not_found : :ok
     json_response(record, status)
   end
=begin   
   def create
     @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
     @transfers = @user.try(:transfers)
     if @transfers
       @transfer =  Transfer.new(transfer_params)
       @transfers << @transfer
       record = @transfer
       status = @transfer.errors.any? ? :unprocessable_entity :  :created
     else
       record = @user.blank? ? "user not found" : @transfer
       status = :not_found
     end
       json_response(record, status)
   end

   def update
     @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
     @transfer = @user.try(:transfers).try{ |obj| obj.where(:id=> params[:id]).first }
     if @transfer
       @transfer.update_attributes(user_params) 
       record = @transfer
       status = @transfer.errors.any? ? :unprocessable_entity :  :ok
     else
      record = @user.blank? ? "user not found" : @transfer
      status = :not_found
     end 
      json_response(record, :not_found)
   end

   def destroy
     @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
     @transfer = @user.try(:transfers).try{ |obj| obj.where(:id=> params[:id]).first }
     if @transfer
       @transfer.destroy 
       record = @transfer
       status = :ok
     else
       record = @user.blank? ? "user not found" : @transfer
       status = :not_found
     end
     json_response(record, status) 
   end


   protected

   def transfer_params
     params.require(:transfer).permit(:key, :value)
   end
=end
end
