class FinancialInstitution < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :ads, dependent: :destroy
  has_many :bank_admins, dependent: :destroy
  has_many :xref_goal_types, dependent: :destroy
  has_one :snapshot_summary
  
  delegate :average_user_balance, :sum_balance, :sum_message_clicks, 
           :total_messages, :total_users, to: :snapshot_summary
  
  validates_presence_of :name, :location
  validates :max_transfer_amount, numericality: { greater_than_or_equal_to: 0}


  after_create :create_default_xref_goals

  before_save :cascade_down_max_transfer_price_to_users

  protected

  def cascade_down_max_transfer_price_to_users
    if self.max_transfer_amount_changed?
      self.users.where("max_transfer_amount > #{self.max_transfer_amount}").update_all(max_transfer_amount: self.max_transfer_amount)
    end
  end
end