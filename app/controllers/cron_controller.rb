class CronController < ApplicationController
  include Transferable
  before_action :cron_env?
  
  def get_transfer_information_for_users
    User.where('max_transfer_amount > 0').map{ |u| send_to_wrapper(u.id, u.max_transfer_amount, u.checking_account_identifier, u.savings_account_identifier, u.financial_institution_id)}
    render :head => :ok
  end

  # This is just an empty action where SQS can output messages.
  def ground
    render :head => :ok
  end

  private

  def cron_env?
    unless ['cron', 'development', 'test'].include? Rails.env
      render_unauthorized("Access denied") and return
    end
  end
end
