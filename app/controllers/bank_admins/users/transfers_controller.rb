class BankAdmins::Users::TransfersController < BankAdmins::ApplicationController
  before_action :find_user

  def index
    @transfers = @user.try(:transfers).where(params[:transfer])
    json_response(@transfers, :ok)
  end

  def show
    @transfer = @user.try(:transfers).find_by(id: params[:id])
    if @transfer
      status = :ok
    else
      status = :not_found
    end
    json_response(@transfer, status)
  end
end
