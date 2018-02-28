class Vendors::Dashboard::Users::OffersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_user_key
  
  def index
    @offer_ids = @user.messages.where(message_obj_type: :Offer).limit(15).pluck(:message_obj_id)
    @offers = Offer.where(id: @offer_ids).order(created_at: :desc) if @offer_ids.present?
    json_response(@offers, [:ad, :xref_goal_type])
  end

  def show
    @offer = @user.messages.find_by(message_obj_type: :Offer, message_obj_id: params[:id]).try(:message_obj)
    json_response(@offer, [:ad, :xref_goal_type])
  end
end
