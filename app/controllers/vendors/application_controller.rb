class Vendors::ApplicationController < ApplicationController
  before_action :require_vendor_login
  
  protected

  def find_goal
    @goal = @user.goals.find_by(id: params[:goal_id])
    if @goal.blank? 
      json_response({:goal => :not_found}, nil, :not_found) and return 
    end
  end

  def vendor_key_with_no_user_exists?
    VendorKey.find_by(key: params[:vendor_key], user_id: nil).any?
  end

  def show_action?
    action_name == "show"
  end

  def find_user_by_vendor_key
    @vendor_key = VendorKey.find_by(key: params[:vendor_key].try(:strip))
    @user ||= @vendor_key.try(:user)
    if @vendor_key.blank?
      json_response({:vendor => :not_found}, nil, :not_found) and return
    elsif @user.blank?
      json_response({:user => :not_found}, nil, :not_found) and return
    end
  end
end
