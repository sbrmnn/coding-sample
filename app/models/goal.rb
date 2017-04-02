class Goal < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :name, :amount, :completion, :priority
  validates_uniqueness_of :name
end
