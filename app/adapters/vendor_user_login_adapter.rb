module VendorUserLoginAdapter
  module BankJoy
    def self.vendor_login(user_id)
      user = User.find(user_id)
      resp = BankJoyService.user_login(user.id)
      if resp["Status"] == 'Failed'
        user.api_errors << ApiError.new(status: resp["Status"], response: resp["Reason"], service: :aws_lambda, function: :login)
      elsif resp["Status"] == 'Success'
        user.api_errors.where(service: :aws_lambda, function: :login).destroy_all
      end
    end
  end
end