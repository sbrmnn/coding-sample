class XrefGoalType < ApplicationRecord
   has_many :goals
   belongs_to :financial_institution
end
