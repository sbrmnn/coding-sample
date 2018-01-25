class Vendors::ApplicationController < ApplicationController
  before_action :require_vendor_login
  
  protected

  def find_financial_institution_by_vendor_key
    @vendor = Vendor.find_by(key: params[:vendor_key].try(:strip))
    @financial_institution = @vendor.try(:financial_institutions)&.find_by(id: params[:financial_institution_id])
    if @vendor.blank?
      json_response({:vendor => :not_found}, nil, :not_found) and return
    elsif @financial_institution.blank?
      json_response({:financial_institution => :not_found}, nil, :not_found) and return 
    end
  end

  def find_user_by_vendor_key
    token =  params[:token] || params[:user_token]
    @vendor = Vendor.find_by(key: params[:vendor_key].try(:strip))
    @user ||= @vendor.try(:users).try{ |obj| obj.find_by(:token => token.try(:strip))}
    if @vendor.blank?
      json_response({:vendor => :not_found}, nil, :not_found) and return
    elsif @user.blank?
      json_response({:user => :not_found}, nil, :not_found) and return
    end
  end
end
