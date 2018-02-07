module Authenticatable
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Respondable

  TOKEN_EXPIRATION = 24.hours.ago

  def require_bank_admin_login
    authenticate_token(BankAdmin) || render_unauthorized("Access denied")
  end

  def require_vendor_login
    authenticate_token(Vendor) || render_unauthorized("Access denied")
  end

  def require_monotto_user_login
    authenticate_token(MonottoUser) || render_unauthorized("Access denied")
  end

  def current_bank_admin
    @current_bank_admin ||= authenticate_token(BankAdmin)
  end

  def current_monotto_user
    @current_monotto_user ||= authenticate_token(MonottoUser) 
  end

  def current_vendor
    @current_vendor ||= authenticate_token(Vendor) 
  end

  def third_party_login(user_obj)
    raise "Argument must be a user object." unless user_obj.is_a? User
    case user_obj
    when user_obj.bankjoy_user?
      BankJoy.user_login(@user.id)
    end
  end


  protected
  
  def get_auth_token(objClass)
    if obj = objClass.valid_login?(params[:email], params[:password])
      obj.generate_token
      send_auth_token_for_valid_login_of(obj)
    else
      render_unauthorized("Error with your login or password")
    end
  end

  private

  def analyze_token_safely(token, obj)
    # Compare the tokens in a time-constant manner, to mitigate timing attacks.
    ActiveSupport::SecurityUtils.secure_compare(
                        ::Digest::SHA256.hexdigest(token),
                        ::Digest::SHA256.hexdigest(obj.token))
  end

  def authenticate_token(model)
    begin
      authenticate_with_http_token do |token, options|
        if model_obj = model.with_unexpired_token(token, TOKEN_EXPIRATION)
          analyze_token_safely(token, model_obj)
          model_obj
        end
      end
    rescue
      return nil
    end
  end
  
  def send_auth_token_for_valid_login_of(obj)
    render json: { token: obj.token }, status: 200
  end
end