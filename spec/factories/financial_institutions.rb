FactoryGirl.define do
  factory(:financial_institution) do
    core "777-777-7777"
    location "Atlanta, Ga"
    max_transfer_amount 70.0
    mobile "777-777-7777"
    name "Monotto Example Bank"
    notes "Sample notes"
    relationship_manager "Dalton Cole"
    transfers_active true
    web "http://www.monotto.com"
  end
end
