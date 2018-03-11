FactoryGirl.define do
  factory(:goal) do
    association(:xref_goal_type, :factory => :xref_goal_type)
    association(:user, :factory => :user)
    target_amount 100000
    balance 10
    priority 1
    tag "House"
    xref_goal_name "Car Goal"
  end
end
