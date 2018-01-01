class Vendors::Users::OffersController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
  before_action :find_user_by_vendor_public_key
  
  def index
    @messages = @user.messages.where(params[:message])
    json_response(@messages)
  end

  def show
    @message = @user.messages.find_by(id: params[:id])
    json_response(@message)
  end



   protected

   def message_params
     if params[:message].blank?
       {}
     else
       params.require(:message).permit(:tag, :priority, :target_amount, :balance, :xref_message_name)
     end
   end
end
