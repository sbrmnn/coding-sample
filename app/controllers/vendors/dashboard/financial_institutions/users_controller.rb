class Vendors::FinancialInstitutions::UsersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login, if: -> { vendor_key_exists? && create_action? }
  before_action :get_financial_institution, if: -> { create_action? }

  def create
    @user = User.new(user_params)
    @financial_institution.users << @user
    json_response(@user)
  end
   
  protected

  def user_params
    if params[:user].blank?
      {}
    else
      params.require(:user).permit(:bank_user_id, :default_savings_account_identifier, :checking_account_identifier,
                                   :transfers_active, :safety_net_active, :max_transfer_amount, :token)
    end
  end

  private

  def get_financial_institution
    @vendor = current_vendor || Vendor.find_by(key: params[:vendor_key].try(:strip))
    if @vendor.blank?
      json_response({:vendor => :not_found}, nil, :not_found) and return
    end
    @financial_institution = @vendor.financial_institutions.find_by(id: params[:financial_institution_id])
    if @financial_institution.blank?
      json_response({:financial_institution => :not_found}, nil, :not_found) and return
    end
  end
end