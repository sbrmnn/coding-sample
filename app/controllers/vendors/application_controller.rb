class Vendors::ApplicationController < ApplicationController
  before_action :require_vendor_login
  
  protected

  def find_user_by_vendor_public_key
    @user ||= Vendor.find(public_key: params[:vendor_public_key]).try(:users).try{ |obj| obj.find_by(:bank_user_id => params[:user_bank_user_id])}
    if @user.blank?
      json_response({}) and return
    end
  end
end
