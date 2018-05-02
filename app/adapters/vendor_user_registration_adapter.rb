module VendorUserRegistrationAdapter
  
  
  
  module Default
    def self.register(user_id)
=begin
     TODO
=end
    end
  end

  module Bankjoy
    def self.register(user_id)
      user =  User.find(user_id)
      resp = BankjoyService.register_user(user.checking_account_identifier)
      if resp["Status"] == 'Failed'
        user.api_errors << ApiError.new(status: resp["Status"], response: resp["Reason"], service: :aws_lambda, function: :registration)
      elsif resp["Status"] == 'Success'
        # Any previous errors associated with the registration should be removed if successful.
        user.api_errors.where(service: :aws_lambda, function: :registration).destroy_all
        goal = Goal.new(tag: "Safety Net", xref_goal_name: "Other Goal", financial_institution: user.financial_institution,
                        priority: 1,  target_amount: resp["Result"]["safety_net"].to_f)
        user.goals << goal
        VendorUserLoginAdapter::Bankjoy.vendor_login(user_id)
      end
    end
  end
end
