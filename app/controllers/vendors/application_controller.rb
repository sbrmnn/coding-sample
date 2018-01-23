class Vendors::ApplicationController < ApplicationController
  before_action :require_vendor_login
  before_action :user_can_login?

 
  protected

  def user_can_login?
    true
  end

  def find_vendor_by_key
    @vendor ||= Vendor.find_by(key: params[:vendor_key].try(:strip))
    if @vendor.blank?
      json_response({:vendor => :not_found}) and return
    end
  end

  def find_user_by_vendor_key
    bank_user_id =  params[:token] || params[:user_token]
    @user ||= find_vendor_by_key.try(:users).try{ |obj| obj.find_by(:bank_user_id => bank_user_id.try(:strip))}
    if @user.blank?
      json_response({:user => :not_found}) and return
    end
  end
end
