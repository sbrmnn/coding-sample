FactoryGirl.define do
  factory(:transfer) do
    amount 500
    destination_account "ASDFASDGSDFGSDFGS"
    origin_account "ASDFASDFASDGDFG"
    association(:user, :factory => :user)
  end
end
