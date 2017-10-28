class MonottoUsers::SessionsController < MonottoUsers::ApplicationController
  skip_before_action :require_monotto_user_login, only: [:create], raise: false
  
  def create
    get_auth_token(MonottoUser)
  end

  def destroy
    current_monotto_user.invalidate_token
    head :ok
  end 
end
