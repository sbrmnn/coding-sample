class BankAdmins::ApplicationController < ApplicationController
  before_action :require_bank_admin_login

  protected

  def find_user
    @user ||= current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
    if @user.blank?
      json_response("user not found", :not_found) and return
    end
  end
end

