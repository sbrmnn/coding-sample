class XrefGoalType < ApplicationRecord
   has_many :goals, dependent: :destroy
   belongs_to :financial_institution
   validates_uniqueness_of :name, :code, scope: :financial_institution_id
end
