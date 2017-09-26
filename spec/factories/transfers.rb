FactoryGirl.define do
  factory(:transfer) do
    amount 500
    destination_account "ASDFASDGSDFGSDFGS"
    origin_account "ASDFASDFASDGDFG"
    status "successful"
    association(:user, :factory => :user)
  end
end
