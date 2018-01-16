class Goal < ApplicationRecord
  attr_accessor :xref_goal_name, :skip_callback
  validates_presence_of :xref_goal_name, if: lambda {xref_goal_type_id.blank? }
  validate :validate_xref_goal_name, if: lambda {financial_institution.present?}
  validates_presence_of :user
  validates :priority, numericality: { greater_than_or_equal_to: 1 }
  validates :target_amount, numericality: { greater_than: 0}
  validates :balance, numericality: { greater_than_or_equal_to: 0}
  has_one :goal_statistic

  delegate :percent_saved, to: :goal_statistic

  belongs_to :user
  belongs_to :xref_goal_type
  has_one :financial_institution, through: :user
  before_save :set_default_savings_account_if_none
  before_save :set_default_savings_account_identifier_if_none
  before_save :rearrange_priority_on_save, if: lambda {priority_changed? && skip_callback.blank?}

  after_destroy { |record| rearrange_priority_on_destroy(record.user_id, record.priority)}

  protected


  def rearrange_priority_on_save
    all_user_goals = Goal.where(user_id: user_id)
    if all_user_goals.where(priority: priority).any?
      index_num = priority - 1
      ActiveRecord::Base.transaction do
        all_user_goals.map{|goal| goal.update_attribute(:priority, 1000 * goal.priority)}
        goals = Goal.where("user_id= ? and id!= ?", user_id, id).order(:priority).map{|g| g}
        goals[index_num] = self
        goals.compact!
        counter = goals.count
        goals.reverse.each do |goal|
          goal.priority = counter
          goal.skip_callback = true
          goal.save unless goal == self
          counter = counter - 1
        end
      end
    end
  end

  def rearrange_priority_on_destroy(user_id, priority)
    goals = Goal.where("user_id = ? and priority >= ?", user_id, priority).order("priority ASC")
    ActiveRecord::Base.transaction do
      goals.each do |goal|
        goal.priority -=1
        goal.skip_callback = true
        goal.save
      end
    end
  end

  def set_default_savings_account_identifier_if_none
    if self.savings_account_identifier.blank?
      self.savings_account_identifier = self.user.default_savings_account_identifier
    end
  end

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
