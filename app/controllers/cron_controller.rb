class CronController < ApplicationController
  include Transferable
  
  def get_transfer_information_for_users
    User.where('max_transfer_amount > 0').map{ |u| send_to_wrapper(u.id, u.max_transfer_amount, u.checking_account_identifier, u.savings_account_identifier, u.financial_institution_id)}
    render :head => :ok
  end
end
