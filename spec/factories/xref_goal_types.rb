FactoryGirl.define do
  factory :xref_goal_type do
  	association(:financial_institution, :factory => :financial_institution)
    code "MOTG"
    name "Mortgage"
    department "Loan"
  end
end
