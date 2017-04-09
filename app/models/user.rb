class User < ApplicationRecord
  has_many :demographics, dependent: :destroy
  has_many :transfers, dependent: :destroy
  has_many :goals, dependent: :destroy
  
  belongs_to :financial_institution
  
  before_save :verify_max_transfer_amount_for_user_is_equal_or_less_than_financial_institution_amount
  
  validates_presence_of :financial_institution, :sequence, :bank_identifier, :savings_account_identifier, :checking_account_identifier
  validates :financial_institution_id, uniqueness: { scope: :bank_identifier }
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
end

