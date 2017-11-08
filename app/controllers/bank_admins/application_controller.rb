class BankAdmins::ApplicationController < ApplicationController
  before_action :require_bank_admin_login

  protected

  def find_user
    @user ||= current_bank_admin.try(:users).try{ |obj| obj.find_by(:bank_user_id => params[:user_bank_user_id])}
    if @user.blank?
      json_response({}) and return
    end
  end
end

