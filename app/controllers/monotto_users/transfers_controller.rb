class MonottoUsers::TransfersController < MonottoUsers::ApplicationController

  before_action :convert_next_transfer_date_to_date

  def index
    @transfers = Transfer.all.where(params[:transfer])
    if @transfers.present?
      status = :ok
    else
      status = :not_found
    end
    json_response(@transfers, status)
  end

  def create
    @transfer = Transfer.create(transfer_params)
    if @transfer.errors.any?
      status = :unprocessable_entity
    else
      status = :created
    end
    json_response(@transfer, status)
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

  def update
    @transfer = Transfer.find_by(id: params[:id])
    if @transfer.present?
      @transfer.update_attributes(transfer_params)
      status = @transfer.errors.any? ? :unprocessable_entity : :ok
    else
      status = :not_found
    end
    json_response(@transfer, status)
  end

  def destroy
   @transfer = Transfer.find_by(id: params[:id]).try(:destroy)
   if @transfer.present?
     status = :ok
   else
     status = :not_found
   end
   json_response(@transfer, status) 
  end

  protected

  def transfer_params
    params.require(:transfer).permit(:user_id, :origin_account, :destination_account, :amount, :transfer_amount_attempted, :next_transfer_date )
  end

  def convert_next_transfer_date_to_date
    if params[:transfer] && params[:transfer][:next_transfer_date].present?
      params[:transfer][:next_transfer_date] = Date.strptime(params[:transfer][:next_transfer_date], "%m/%d/%Y")
    end
  end
end
