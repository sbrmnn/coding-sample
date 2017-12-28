FactoryGirl.define do
  factory(:user) do
    checking_account_identifier "ASDFASDFASDGDFG"
    association(:financial_institution, :factory => :financial_institution)
    max_transfer_amount 30
    safety_net_active true
    default_savings_account_identifier "ASDFASDGSDFGSDFGS"
    transfers_active true
  end
end
