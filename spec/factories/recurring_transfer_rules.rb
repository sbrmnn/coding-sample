FactoryGirl.define do
  factory :recurring_transfer_rule do
    association(:goal, :factory => :goal)
    amount 10
    frequency 'day'
    repeats 1
    start_dt Time.now 
    deleted_at nil 
  end
end
