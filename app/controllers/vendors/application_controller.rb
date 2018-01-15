class Vendors::ApplicationController < ApplicationController
  before_action :require_vendor_login
  
  protected

  def find_user_by_vendor_key
    bank_user_id =  params[:token] || params[:user_token]
    @user ||= Vendor.find_by(key: params[:vendor_key].try(:strip)).try(:users).try{ |obj| obj.find_by(:bank_user_id => bank_user_id.try(:strip))}
    if @user.blank?
      json_response({}) and return
    end
  end
end
