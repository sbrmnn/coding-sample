class BankAdmin < ApplicationRecord
  include ModelAuthenticatable
  has_many :users, through: :financial_institution, dependent: :destroy
  belongs_to :financial_institution
end
