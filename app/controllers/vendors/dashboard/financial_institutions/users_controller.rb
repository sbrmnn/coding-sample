class Vendors::Dashboard::FinancialInstitutions::UsersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :get_financial_institution

  def create
    @user = User.new(user_params)
    @user.vendor_user_key_val = params[:vendor_user_key]
    @financial_institution.users << @user
    json_response(@user)
  end
   
  protected

  def user_params
    if params[:user].blank?
      {}
    else
      params.require(:user).permit(:bank_user_id, :default_savings_account_identifier, :checking_account_identifier,
                                   :transfers_active, :max_transfer_amount)
    end
  end

  private

  def get_financial_institution
    @vendor = VendorUserKey.find_by(key: params[:vendor_user_key].try(:strip)).try(:vendor)
    if @vendor.blank?
      json_response({:vendor => :not_found}, nil, :not_found) and return
    end
    @financial_institution = @vendor.financial_institutions.find_by(id: params[:financial_institution_id])
    if @financial_institution.blank?
      json_response({:financial_institution => :not_found}, nil, :not_found) and return
    end
  end
end