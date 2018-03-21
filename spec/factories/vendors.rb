FactoryGirl.define do
  factory :vendor do
   name "bankjoy"
   location "United States"
   core nil
   web nil
   mobile nil 
   sequence(:email){|n| "user#{n}@factory.com" } 
   notes nil 
   password "Password01"
  end
end
