class Vendors::Dashboard::Users::OfferMessagesController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_key

  def update
  	@offer_message = @user.messages.find_by(message_obj_id: params[:offer_id], message_obj_type: :Offer)
    if @offer_message
      Message.increment_counter(:clicks, @offer_message.id)
      @offer_message.reload
    end
    json_response(@offer_message)
  end
end
