class User < ApplicationRecord
  has_many :demographics, dependent: :destroy
  has_many :transfers, dependent: :destroy
  has_one :vendor, through: :financial_institution
  has_many :goals, dependent: :destroy
  belongs_to :financial_institution
  has_many :messages, dependent: :destroy
  has_many :transactions, dependent: :destroy
  before_save :verify_max_transfer_amount_for_user_is_equal_or_less_than_financial_institution_amount
  validates :max_transfer_amount, numericality: {greater_than: 0}
  validates_presence_of :bank_user_id,
                        :default_savings_account_identifier, :checking_account_identifier
  
  validates_uniqueness_of :bank_user_id, scope: [:financial_institution_id]
  validate :ensure_one_bank_user_id_per_vendor,  if: lambda {vendor.present? && bank_user_id_changed?}
  validate :ensure_one_token_per_vendor,  if: lambda {vendor.present? && token_changed?}
  before_save :generate_token_if_none
  has_many :api_errors
  after_create :insert_transfer_record
  after_commit :register_bankjoy_user, on: :create, if: lambda {bankjoy_user?}

  def bankjoy_user?
    vendor.try(:bankjoy_vendor?).present?
  end

  protected

  def register_bankjoy_user
    resp = BankJoy.register_user(checking_account_identifier)
    if resp["Status"] == 'Failure'
      self.api_errors << ApiError.new(status: resp["Status"], response: resp["Reason"], service: "aws_lambda", function: 'registration')
    else
      # Any previous errors associated with the registration should be removed if successful.
      self.api_errors.where(service: :aws_lambda, function: :registration).destroy_all
    end
  end

  def generate_token_if_none
    if self.token.blank?
      token_length = 50
      self.token = SecureRandom.urlsafe_base64(token_length)
      while User.exists?(:token => token, financial_institution_id: financial_institution_id) # Making sure token hasn't been assigned for another vendor.
        self.token = SecureRandom.urlsafe_base64(token_length)
      end
    end
  end

  def ensure_one_bank_user_id_per_vendor
    if vendor.users.where.not(id: id).where(bank_user_id: bank_user_id).any?
      errors.add(:bank_user_id, 'already exists for another user.')
    end
  end

  def ensure_one_token_per_vendor
    if vendor.users.where.not(id: id).where(token: token).any?
      errors.add(:token, 'not valid.')
    end
  end

  def verify_max_transfer_amount_for_user_is_equal_or_less_than_financial_institution_amount
    financial_institution_max_transfer = self.financial_institution.max_transfer_amount
    if self.max_transfer_amount > financial_institution_max_transfer
      self.max_transfer_amount = financial_institution_max_transfer
    end
  end


  def insert_transfer_record
    Transfer.create(user: self, next_transfer_date: nil, amount: 0,
                    end_date: 'infinity', status: :pending, origin_account: checking_account_identifier, destination_account: default_savings_account_identifier)
  end
end

