class MonottoUsers::ApplicationController < ApplicationController
  before_action :require_monotto_user_login

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
