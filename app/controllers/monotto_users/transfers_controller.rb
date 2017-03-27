class MonottoUsers::TransfersController < MonottoUsers::ApplicationController
   
   def index
     @transfers = Transfer.all.where(params[:transfer])
     if @transfers.present?
       status = :ok
     else
       status = :not_found
     end
     json_response(@transfers, status)
   end

   def show
     @transfer = Transfer.find_by(id: params[:id])
     if @transfer
      status = :ok
     else
      status = :not_found
     end
      json_response(@transfer, status)
   end

   def create
     @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
     @transfers = @user.try(:transfers)
     if @transfers.present?
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
      @transfer = Transfer.find_by(id: params[:id]).try{ |obj| obj.update_attributes(params[:transfer])}
      if @transfer.present?
        status = :ok
      else
        status = :not_found
      end
      json_response(@transfer, status)
   end

   def destroy
     @transfer = Transfer.find_by(id: params[:id]).try(:destroy)
     if @transfers.present?
       status = :ok
     else
       status = :not_found
     end
     json_response(@transfer, status) 
   end

   protected

   def transfer_params
     params.require(:transfer).permit(:key, :value)
   end
end
