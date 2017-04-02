FactoryGirl.define do
  factory(:demographic) do
    key "race"
    association(:user, :factory => :user)
    value "white"
  end
end
