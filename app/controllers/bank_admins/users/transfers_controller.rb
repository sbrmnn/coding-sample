class BankAdmins::Users::TransfersController < BankAdmins::ApplicationController
  before_action :find_user

  def index
    @transfers = @user.try(:transfers).select(:id, :origin_account, :destination_account, :amount, :created_at, :updated_at).where(params[:transfer])
    json_response(@transfers, :ok)
  end

  def show
    @transfer = @user.try(:transfers).select(:id, :origin_account, :destination_account, :amount, :created_at, :updated_at).find_by(id: params[:id])
    if @transfer
      status = :ok
    else
      status = :not_found
    end
    json_response(@transfer, status)
  end
end
