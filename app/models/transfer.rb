class Transfer < ApplicationRecord
  belongs_to :user
  
  validates_presence_of :user, :origin_account, :destination_account

  validates :amount, numericality: { greater_than_or_equal_to: 0}
end
