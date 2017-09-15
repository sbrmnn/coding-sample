class User < ApplicationRecord
  has_many :demographics, dependent: :destroy
  has_one :transfer, dependent: :destroy
  has_many :goals, dependent: :destroy
  belongs_to :financial_institution

  before_save :verify_max_transfer_amount_for_user_is_equal_or_less_than_financial_institution_amount
  after_create :insert_transfer_record
  validates :max_transfer_amount, numericality: { greater_than_or_equal_to: 0}
  validates_presence_of :financial_institution, :sequence, :bank_user_id,
                        :savings_account_identifier, :checking_account_identifier
  validates :bank_user_id, uniqueness: { scope: :financial_institution_id }
  
  protected

  def verify_max_transfer_amount_for_user_is_equal_or_less_than_financial_institution_amount
    if self.max_transfer_amount.present?
      financial_institution_max_transfer = self.financial_institution.max_transfer_amount
      if self.max_transfer_amount > financial_institution_max_transfer
        self.max_transfer_amount = financial_institution_max_transfer
      end
    else
      self.max_transfer_amount = 0 
    end
  end

  def insert_transfer_record
    Transfer.create(user: self, next_transfer_date: nil, amount: 0,
                    end_date: 'infinity')
  end
end

