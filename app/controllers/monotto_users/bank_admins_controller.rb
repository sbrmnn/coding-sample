class MonottoUsers::BankAdminsController < MonottoUsers::ApplicationController

  def index
    @bank_admins = BankAdmin.all.where(params[:bank_admin])
    if @bank_admins.present?
      status = :ok
    else
      status = :not_found
    end
    json_response(@bank_admins, status)
  end

  def show
    @bank_admin = BankAdmin.find_by(id: params[:id])
    if @bank_admin
      status = :ok
    else
      status = :not_found
    end
    json_response(@bank_admin, status)
  end

  def create
    @bank_admin = BankAdmin.create(bank_admin_params)
    if @bank_admin.errors.any?
      status = :unprocessable_entity
    else
      status = :created
    end
    json_response(@bank_admin, status)
  end

  def update
    @bank_admin = BankAdmin.find_by(id: params[:id])
    if @bank_admin.present?
      @bank_admin.update_attributes(bank_admin_params)
      status = @bank_admin.errors.any? ? :unprocessable_entity : :ok
    else
      status = :not_found
    end
    json_response(@bank_admin, status)
  end

  def destroy
    @bank_admin = BankAdmin.find_by(id: params[:id]).try(:destroy)
    if @bank_admin.present?
      status = :ok
    else
      status = :not_found
    end
    json_response(@bank_admin, status) 
  end

  protected

  def bank_admin_params
    params.require(:bank_admin).permit(:financial_institution_id, :email, :name, :title, :phone, :notes, :is_primary, :password)
  end
end
