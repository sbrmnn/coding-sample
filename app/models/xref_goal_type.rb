class XrefGoalType < ApplicationRecord
   before_validation :upcase_code
   before_validation :humanize_and_titleize_name
   has_many :goals, dependent: :destroy
   belongs_to :financial_institution
   validates_uniqueness_of :name, :code, scope: :financial_institution_id
   validates_presence_of :name, :code
   has_many :xref_goal_type_stats

   protected

   def humanize_and_titleize_name
     self.name = name.try(:humanize).try(:titleize)
   end

   def upcase_code
     self.code = code.try(:upcase)
   end
end
