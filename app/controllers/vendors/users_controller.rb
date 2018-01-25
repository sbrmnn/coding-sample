class Vendors::UsersController < Vendors::ApplicationController
  before_action :ensure_financial_institution_belongs_to_vendor, if: :financial_institution_id_present?, only: [:create. :update]
  skip_before_action :require_vendor_login, only: [:show, :update]
  before_action :find_user_by_vendor_key, only: [:show, :update]
  def index
    @users = current_vendor.users
    json_response(@users)
  end

  def create
    @user = User.new(user_params)
    current_vendor.users << @user
    json_response(@user)
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
     params.require(:user).permit(:token, :financial_institution_id, :checking_account_identifier,
                                  :default_savings_account_identifier, :transfers_active,
                                  :safety_net_active)
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
