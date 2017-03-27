class FinancialInstitution < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :bank_admins, dependent: :destroy
end
