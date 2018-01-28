class Vendors::ApplicationController < ApplicationController
  before_action :require_vendor_login
  
  protected

  def vendor_key_exists?
    params[:vendor_key].present?
  end

  def show_action?
    action_name == "show"
  end

  def create_action?
    action_name == "create"
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
