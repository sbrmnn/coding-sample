class MonottoUsers::SessionsController < MonottoUsers::ApplicationController

  before_action :require_monotto_user_login, only: [:destroy], raise: false

  def create
  	check_valid_login?(MonottoUser)
  end

  def destroy
    current_monotto_user.invalidate_token
    head :ok
  end 
end
