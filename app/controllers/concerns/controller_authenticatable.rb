module ControllerAuthenticatable
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Response

  TOKEN_EXPIRATION = 24.hours.ago

  def require_bank_admin_login
    authenticate_bank_admin_token || render_unauthorized("Access denied")
  end

  def require_vendor_login
    authenticate_token(Vendor) || render_unauthorized("Access denied")
  end

  def require_monotto_user_login
    authenticate_monotto_user_token || render_unauthorized("Access denied")
  end

  def current_bank_admin
    @current_bank_admin ||= authenticate_bank_admin_token
  end

  def current_monotto_user
    @current_monotto_user ||= authenticate_monotto_user_token
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

  def authenticate_monotto_user_token
    begin
      authenticate_with_http_token do |token, options|
        if monotto_user = MonottoUser.with_unexpired_token(token, TOKEN_EXPIRATION)
          analyze_token_safely(token, monotto_user)
          monotto_user
        end
      end
    rescue
      return nil
    end
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
  
  def authenticate_bank_admin_token
    begin
      authenticate_with_http_token do |token, options|
        if bank_admin = BankAdmin.with_unexpired_token(token, TOKEN_EXPIRATION)
          analyze_token_safely(token, bank_admin)
          bank_admin
        end
      end
    rescue
      return nil
    end
  end

  def authenticate_vendor_token
    begin
      authenticate_with_http_token do |token, options|
        if vendor = Vendor.with_unexpired_token(token, TOKEN_EXPIRATION)
          analyze_token_safely(token, vendor)
          vendor
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