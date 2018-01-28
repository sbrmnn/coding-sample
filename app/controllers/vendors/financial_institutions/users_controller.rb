class Vendors::FinancialInstitutions::UsersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login, if: -> { vendor_key_exists? && create_action? }
  before_action :get_financial_institution, if: -> { create_action? }

  def create
    get_financial_institution
    @user = @financial_institution.users.where(checking_account_identifier: user_params[:checking_account_identifier]).first_or_create do |user|
              # This block only runs if a new user is created.
              user.default_savings_account_identifier = user_params[:default_savings_account_identifier]
              user.token = user_params[:token]
              user.bank_user_id = user_params[:bank_user_id]
              user.max_transfer_amount = user_params[:max_transfer_amount]
    end
    check_if_checking_account_exists_for_another_user
    if @error.present?
      json_response(@error, nil, :bad_request) and return
    end
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
    if current_vendor
      @financial_institution = current_vendor.financial_institutions.where(id: params[:financial_institution_id])
    else
      @vendor = Vendor.find_by(key: params[:vendor_key].try(:strip))
      if @vendor.blank? && vendor_key_exists?
        json_response({:vendor => :not_found}, nil, :not_found) and return
      end
      @financial_institution = @vendor.try(:financial_institutions)&.find_by(id: params[:financial_institution_id])
    end
    if @financial_institution.blank?
      json_response({:financial_institution => :not_found}, nil, :not_found) and return
    end
  end

  def check_if_checking_account_exists_for_another_user
    # If another user with the same checking account id within a financial institution tries to signup,
    # we want to state that they need to choose a different checking account.
    @error = {error: "Please select another checking account."} if (@user.token != user_params[:token])
  end
end