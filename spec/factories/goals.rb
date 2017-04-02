FactoryGirl.define do
  factory(:goal) do
  	association(:user, :factory => :user)
  	name "Save for a House"
  	amount 100000
  	completion 10
  	priority 1
  	tag "House"
  end
end
