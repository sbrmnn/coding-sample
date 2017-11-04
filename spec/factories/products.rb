FactoryGirl.define do
  factory :product do
    association(:financial_institution, :factory => :financial_institution)
    name "Sample Name"
  end
end
