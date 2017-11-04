class Goal < ApplicationRecord
  attr_accessor :xref_goal_name
  belongs_to :user
  belongs_to :xref_goal_type
  validates_presence_of :user
  validate :validate_xref_goal_name
  validates :priority, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :target_amount, numericality: { greater_than: 0}
  validates :balance, numericality: { greater_than: 0}
  validates_presence_of :user
  validates_uniqueness_of :priority, :scope => :user_id
  has_one :goal_statistic
  delegate :percent_saved, to: :goal_statistic

  protected
  
  def validate_xref_goal_name
    if xref_goal_name
      prod_obj = self.financial_institution.xref_goa.where(name: product_name).first
      if prod_obj
        self.product_id = prod_obj.id
      else
        errors.add(:goal_name, 'doesn\'t exist')
      end
    end
  end

end
