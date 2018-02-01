class Goal < ApplicationRecord
  attr_accessor :xref_goal_name, :no_callback
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
  before_save :set_default_savings_account_identifier_if_none
  before_save :set_savings_account_balance
  before_save :rearrange_priority_on_save, if: lambda {priority_changed? && no_callback.blank?}

  after_destroy { |record| rearrange_priority_on_destroy(record.user_id, record.priority)}
  after_destroy :recalculate_goal_balance_for_destroy_goal
  before_create :recalculate_goal_balance_for_new_goal
  before_update :recalculate_goal_balance_for_updated_goal, if: lambda {target_amount_changed?}
  after_destroy :check_of_user_qualifies_for_offers
  after_update  :check_of_user_qualifies_for_offers, if: lambda {target_amount_changed?}

  protected


  def check_of_user_qualifies_for_offers
    user = User.where(id: user_id).first
    if user
      messages = user.messages.where(message_obj_type: :Offer)
      messages.each do |msg|
        msg.message_obj.destroy unless msg.message_obj.user_qualifies?(user.id)
      end
    end
  end

  def recalculate_goal_balance_for_new_goal
    goals = Goal.all.where(user_id: self.user_id)
    sum_balance_of_goals = goals.sum(:balance)
    savings_acct_balance = goals.pluck(:savings_account_identifier, :savings_acct_balance).uniq.map{|r| r[1]}.sum
    diff = savings_acct_balance - sum_balance_of_goals
    return if diff < 0
    if self.target_amount - diff >= 0
      self.balance = diff
    else
      self.balance = target_amount
    end
  end

  def recalculate_goal_balance_for_destroy_goal
    goals = Goal.where(user_id: self.user_id).order(priority: :asc)
    sum_balance_of_goals = goals.sum(:balance)
    savings_acct_balance = goals.pluck(:savings_account_identifier, :savings_acct_balance).uniq.map{|r| r[1]}.sum
    diff = self.balance
    goals.each do |goal|
      goal_diff = (goal.target_amount - goal.balance)
      if diff >= goal_diff
        goal.balance = goal.balance + goal_diff
        goal.save
        diff =  diff - goal_diff;
      elsif diff < goal_diff
        goal.balance = goal.balance + diff
        goal.save
        break;
      end 
    end
  end

  def recalculate_goal_balance_for_updated_goal
    diff = target_amount - balance 
    goals =  Goal.where(user_id: user_id)
    if diff < 0
      diff = diff.abs
      self.balance = target_amount
      goals.where.not(id: id).order(priority: :asc).each do |goal|
        goal_diff = (goal.target_amount - goal.balance)
        if diff >= goal_diff 
          goal.balance = goal.balance + goal_diff
          goal.save
          diff =  diff - goal_diff;
        elsif diff < goal_diff
          goal.balance = goal.balance + diff
          goal.save
          break;
        end 
      end
    elsif diff > 0
      sum_balance_of_goals = goals.sum(:balance)
      savings_acct_balance = goals.pluck(:savings_account_identifier, :savings_acct_balance).uniq.map{|r| r[1]}.sum
      leftover = savings_acct_balance - sum_balance_of_goals
      self.update_attribute(:balance,  target_amount) if ((balance + leftover) >= target_amount) 
      self.increment(:balance,  leftover) if ((balance + leftover) < target_amount) 
    end
  end

  def rearrange_priority_on_save
    all_user_goals = Goal.where(user_id: user_id)
    if all_user_goals.where(priority: priority).any?
      index_num = priority - 1
      ActiveRecord::Base.transaction do
        # This code temporarily updates the priorities as a work around
        # to make sure we don't run into database errors when recalculating
        # and saving priorities for existing goals.
        all_user_goals.each do |goal|
          goal.no_callback = true
          goal.update_attribute(:priority, 1000 * goal.priority)
        end
        goals = Goal.where(user_id: user_id).where.not(id: id).order(:priority).map{|g| g}
        goals.insert(index_num, self)
        goals.compact!
        counter = 1
        goals.each do |goal|
          goal.priority = counter
          goal.no_callback = true
          goal.save
          counter = counter + 1
        end
      end
    end
  end

  def rearrange_priority_on_destroy(user_id, priority)
    goals = Goal.where("user_id = ? and priority >= ?", user_id, priority).order("priority ASC")
    ActiveRecord::Base.transaction do
      goals.each do |goal|
        goal.priority -=1
        goal.no_callback = true
        goal.save
      end
    end
  end

  def set_default_savings_account_identifier_if_none
    if self.savings_account_identifier.blank?
      self.savings_account_identifier = self.user.default_savings_account_identifier
    end
  end

  def set_savings_account_balance
    self.savings_acct_balance = Goal.where(savings_account_identifier: savings_account_identifier, user_id: user_id).first.try(:savings_acct_balance).to_i
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
