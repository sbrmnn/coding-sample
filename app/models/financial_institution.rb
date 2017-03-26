class FinancialInstitution < ApplicationRecord
	has_many :users
	has_many :bank_admins
end
