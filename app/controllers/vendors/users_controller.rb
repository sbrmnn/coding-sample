class Vendors::UsersController < Vendors::ApplicationController
  before_action :ensure_financial_institution_belongs_to_vendor, if: :financial_institution_id_present?, only: [:update]
  before_action :ensure_financial_institution_belongs_to_vendor, only: [:create]
  skip_before_action :require_vendor_login, only: [:create, :show, :update]
  before_action :find_user_by_vendor_key, only: [:show, :update]
  
  def index
    @users = current_vendor.users
    json_response(@users)
  end

  def create
    @user = User.where(checking_account_identifier: user_params[:checking_account_identifier], financial_institution_id: @financial_institution.id).first_or_create do |user|
              user.default_savings_account_identifier = user_params[:default_savings_account_identifier]
              user.token = user_params[:token]
              user.bank_user_id = user_params[:bank_user_id]
              user.max_transfer_amount = user_params[:max_transfer_amount]
            end
    @error = {error: "Please select another checking account."} if (@user.token != user_params[:token])
    # If another user with the same checking account id within a vendor tries to signup,
    # we want to block them from logging in and state that they need to choose a different checking account.
    # Users differ from each other by the token value; hence, the reason why are checking
    # to make sure the token passed in matches with the existing record existing record.
    @error.present? ? json_response(@error, nil, :bad_request) : json_response(@user)
  end
  
  def show
    json_response(@user)
  end

  def update
    @user.update_attributes(user_params)
    json_response(@user) 
  end

  protected

  def user_params
   if params[:user].blank?
     {}
   else
     params.require(:user).permit(:bank_user_id, :default_savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :safety_net_active, :max_transfer_amount, :token, :financial_institution_id)
   end
  end

  private

  def financial_institution_id_present?
    user_params[:financial_institution_id].present?
  end

  def ensure_financial_institution_belongs_to_vendor
    if current_vendor.financial_institutions.where(financial_institution_id: user_params[:financial_institution_id]).empty?
      json_response({:financial_institution => :not_found}, nil, :not_found) and return
    end
  end
end
