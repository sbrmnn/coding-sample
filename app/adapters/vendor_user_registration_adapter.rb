module VendorUserRegistrationAdapter
  
  def self.set_user(user_id)
    User.find(user_id)
  end
  
  module Default
    def self.register(user_id)
=begin
      user = VendorUserRegistrationAdapter.set_user(user_id)
      goal = Goal.new(tag: "Safety Net", xref_goal_name: "Other Goal", financial_institution: user.financial_institution,
                    priority: 1,  target_amount: 25.to_f)
      user.goals << goal
    end
=end
  end

  module BankJoy
    def self.register(user_id)
      user = VendorUserRegistrationAdapter.set_user(user_id)
      resp = BankJoyService.register_user(user.checking_account_identifier)
      if resp["Status"] == 'Failed'
        user.api_errors << ApiError.new(status: resp["Status"], response: resp["Reason"], service: :aws_lambda, function: :registration)
      elsif resp["Status"] == 'Success'
        goal = Goal.new(tag: "Safety Net", xref_goal_name: "Other Goal", financial_institution: user.financial_institution,
                        priority: 1,  target_amount: resp["Result"]["safety_net"].to_f)
        user.goals << goal
        VendorUserLoginAdapter::BankJoy.vendor_login(user_id)
        # Any previous errors associated with the registration should be removed if successful.
        user.api_errors.where(service: :aws_lambda, function: :registration).destroy_all
      end
    end
  end
end