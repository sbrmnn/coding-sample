class Vendors::ApplicationController < ApplicationController
  before_action :require_vendor_login
  
  protected

  def find_goal
    @goal = @user.goals.find_by(id: params[:goal_id])
    if @goal.blank? 
      json_response({:goal => :not_found}, nil, :not_found) and return 
    end
  end

  def show_action?
    action_name == "show"
  end

  def find_user_by_vendor_user_key
    @vendor_user_key = VendorUserKey.find_by(key: params[:vendor_user_key].try(:strip))
    @vendor = @vendor_user_key.try(:vendor)
    @user ||= @vendor_user_key.try(:user)
    if @vendor.blank?
      json_response({:vendor => :not_found}, nil, :not_found) and return
    elsif @user.blank?
      json_response({:user => :not_found}, nil, :not_found) and return
    end
  end
end
