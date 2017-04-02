class Transfer < ApplicationRecord
  belongs_to :user
  
  validates_presence_of :user, :origin_account, :destination_account, :amount
end
