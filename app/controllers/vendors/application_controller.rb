class Vendors::ApplicationController < ApplicationController
  before_action :require_vendor_login
  protected

  def find_user
    @user ||= current_vendor.try(:users).try{ |obj| obj.find_by(:bank_user_id => params[:user_bank_user_id])}
    if @user.blank?
      json_response({}) and return
    end
  end
end
