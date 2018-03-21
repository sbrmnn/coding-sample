FactoryGirl.define do
  factory :vendor_user_key do
    association(:vendor, :factory => :vendor)
  end
end
