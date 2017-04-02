FactoryGirl.define do
  factory(:bank_admin) do
  	association(:financial_institution, :factory => :financial_institution)
    email "admin@monotto.com"
    name "Dalton Cole"
    title "Branch Manager"
    phone "777-777-7777" 
    notes "Sample notes" 
    is_primary false
    password "Password01"
  end
end
