class XrefGoalType < ApplicationRecord
   has_many :goals
   belongs_to :financial_institution
   validates_uniqueness_of :name, :code, scope: :financial_institution_id
end
