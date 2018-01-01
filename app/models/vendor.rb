class Vendor < ApplicationRecord
    has_many :users, through: :financial_institutions
    has_many :financial_institutions
end
