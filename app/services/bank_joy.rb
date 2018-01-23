class BankJoy
  def self.register_user(checking_account_identifier)
  	payload = {"account_id": checking_account_identifier, "function": "registration"}
    resp = AwsLambdaService.new('bj_wrapper', payload).response
  end

  def self.login
  end
end