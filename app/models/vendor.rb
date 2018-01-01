class Vendor < ApplicationRecord
    has_many :users
    has_many :financial_institutions
end
