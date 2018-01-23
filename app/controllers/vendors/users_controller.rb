class Vendors::UsersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login, except: [:index]
  before_action :find_user_by_vendor_key,   except: [:index, :create]
  before_action :find_vendor_by_key,        only: [:create]

  def index
    @users = current_vendor.users
    json_response(@users)
  end

  def create
    @user = User.where(checking_account_identifier: params[:checking_account_identifier], vendor_id: @vendor.id).first_or_create do |user|
     user.default_savings_account_identifier = params[:default_savings_account_identifier]
     user.token = params[:token]
    end
    @error = {error: "Please select another checking account."} if (@user.token != params[:token]) 
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
    params.require(:user).permit(:checking_account_identifier, :default_savings_account_identifier, :transfers_active, :safety_net_active)
    end
  end
end
