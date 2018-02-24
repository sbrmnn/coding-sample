class BankJoyService
  def self.register_user(checking_account_identifier)
    payload = {"account_id": checking_account_identifier, "function": "registration"}
    lambda_response(payload)
  end

  def self.user_login(user_id)
    return "Not a BankJoy user." unless User.find(user_id).bankjoy_user?
    payload = {"user_id": user_id, "function": "userlogin"}
    lambda_response(payload)
  end

  private

  def self.lambda_response(payload)
     AwsLambdaService.new('bj_wrapper', payload).response
  end
end