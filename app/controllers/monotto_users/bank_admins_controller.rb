class MonottoUsers::BankAdminsController < MonottoUsers::ApplicationController

  def index
    @bank_admins = BankAdmin.all.where(params[:bank_admin])
    json_response(@bank_admins)
  end

  def show
    @bank_admin = BankAdmin.find_by(id: params[:id])
    json_response(@bank_admin)
  end

  def create
    @bank_admin = BankAdmin.create(bank_admin_params)
    json_response(@bank_admin)
  end

  def update
    @bank_admin = BankAdmin.find_by(id: params[:id])
    if @bank_admin.present?
      @bank_admin.update_attributes(bank_admin_params)
    end
    json_response(@bank_admin)
  end

  def destroy
    @bank_admin = BankAdmin.find_by(id: params[:id]).try(:destroy)
    json_response(@bank_admin) 
  end

  protected

  def bank_admin_params
    params.require(:bank_admin).permit(:financial_institution_id, :email, :name, :title, :phone, :notes, :is_primary, :password)
  end
end
