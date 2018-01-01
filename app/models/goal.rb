class Goal < ApplicationRecord
  attr_accessor :xref_goal_name
  validates_presence_of :xref_goal_name, if: lambda { self.xref_goal_type_id.blank? }
  validate :validate_xref_goal_name
  validates_presence_of :user
  validates :priority, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :target_amount, numericality: { greater_than: 0}
  validates :balance, numericality: { greater_than_or_equal_to: 0}
  validates_presence_of :user
  validates_uniqueness_of :priority, :scope => :user_id
  has_one :goal_statistic
  has_one :financial_institution, through: :user
  delegate :percent_saved, to: :goal_statistic

  belongs_to :user
  belongs_to :xref_goal_type

  before_save :set_default_savings_account_if_none

  protected

  def set_default_savings_account_if_none
    if savings_account_identifier.blank?
      self.savings_account_identifier = self.user.default_savings_account_identifier
    end
  end
  
  def validate_xref_goal_name
    if xref_goal_name
      xref_goal_name_obj = self.financial_institution.xref_goal_types.where(name: xref_goal_name).first
      if xref_goal_name_obj
        self.xref_goal_type_id = xref_goal_name_obj.id
      else
        errors.add(:xref_goal_name, 'doesn\'t exist')
      end
    end
  end

end
