module Loginable
  extend ActiveSupport::Concern
  
  included do
    has_secure_password
    has_secure_token
  end

  def generate_token
    regenerate_token
    touch(:token_created_at)
  end
  
  def invalidate_token
    update_columns(token: nil)
    touch(:token_created_at)
  end

  module ClassMethods	
    
    def with_unexpired_token(token, period)
      where(token: token).where('token_created_at >= ?', period).first
    end  

    def valid_login?(email, password)
      obj = find_by(email: email)
      if obj && obj.authenticate(password)
        obj
      end
    end
  end
end