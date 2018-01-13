class FinancialInstitution < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :ads, dependent: :destroy
  has_many :bank_admins, dependent: :destroy
  has_many :xref_goal_types, dependent: :destroy
  has_many :goals, through: :users 
  has_many :historical_snapshots, dependent: :destroy
  has_many :transfers, through: :users , dependent: :destroy
  has_many :messages, through: :users 
  has_many :historical_snapshots
  has_one :snapshot_summary
  has_many :historical_snapshot_stats
  belongs_to :vendor, optional: true
  delegate :average_user_balance, :sum_balance, :sum_message_clicks, 
           :total_messages, :total_users, to: :snapshot_summary
  
  validates_presence_of :name, :location
  validates :max_transfer_amount, numericality: { greater_than_or_equal_to: 0}


  after_create :create_default_xref_goals

  before_save :cascade_down_max_transfer_price_to_users

  after_commit :create_historical_snapshot_if_none

  protected

  def create_historical_snapshot_if_none
    if self.historical_snapshots.blank?
      @snapshot_summary = SnapshotPresenter.new(self.id).archive
    end
  end

  def create_default_xref_goals
    self.xref_goal_types << XrefGoalType.new(code: "CAR",     name: "Car Goal")
    self.xref_goal_types << XrefGoalType.new(code: "HOUSE",   name: "House Goal")
    self.xref_goal_types << XrefGoalType.new(code: "VACA",    name: "Vacation Goal")
    self.xref_goal_types << XrefGoalType.new(code: "OTHER",   name: "Other Goal")
  end

  def cascade_down_max_transfer_price_to_users
    if self.max_transfer_amount_changed?
      self.users.where("max_transfer_amount > #{self.max_transfer_amount}").update_all(max_transfer_amount: self.max_transfer_amount)
    end
  end
end
