module VendorUserRegistrationAdapter
  extend VendorUserLoginAdapter
  module Default
    def self.register(user_id)
      user = set_user(user_id)
      goal = Goal.new(tag: "Safety Net", xref_goal_name: "Other Goal", financial_institution: user.financial_institution,
                    priority: 1,  target_amount: 25.to_f)
      user.goals << goal
    end
    def self.set_user(user_id)
       User.find(user_id)
    end
  end
  module Bankjoy
    extend Default
    def self.register(user_id)
      user = set_user(user_id)
      resp = BankJoyService.register_user(user.checking_account_identifier)
        if resp["Status"] == 'Failure'
          user.api_errors << ApiError.new(status: resp["Status"], response: resp["Reason"], service: :aws_lambda, function: :registration)
        elsif resp["Status"] == 'Success'
          goal = Goal.new(tag: "Safety Net", xref_goal_name: "Other Goal", financial_institution: user.financial_institution,
                          priority: 1,  target_amount: resp["Result"]["safety_net"].to_f)
          user.goals << goal
          vendor_login(user_id)
          # Any previous errors associated with the registration should be removed if successful.
          user.api_errors.where(service: :aws_lambda, function: :registration).destroy_all
        end
    end
  end
end