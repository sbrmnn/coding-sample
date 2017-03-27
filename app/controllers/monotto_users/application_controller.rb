class MonottoUsers::ApplicationController < ApplicationController
  before_filter :require_bank_admin_login

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
