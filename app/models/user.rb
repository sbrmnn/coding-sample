class User < ApplicationRecord
  attr_accessor :vendor_user_key
  has_many :demographics, dependent: :destroy
  has_many :transfers, dependent: :destroy
  has_one :vendor, through: :financial_institution
  has_many :goals, dependent: :destroy
  belongs_to :financial_institution
  has_many :messages, dependent: :destroy
  has_many :transactions, dependent: :destroy
  before_save :verify_max_transfer_amount_for_user_is_equal_or_less_than_financial_institution_amount
  validates :max_transfer_amount, numericality: {greater_than: 0}
  validate :vendor_user_key_with_no_user, on: :create, if: lambda {vendor.present?}
  validates_presence_of :bank_user_id,
                        :default_savings_account_identifier, :checking_account_identifier
  
  validates_uniqueness_of :bank_user_id, scope: [:financial_institution_id], unless: lambda {vendor.present?}
  validates_uniqueness_of :checking_account_identifier, scope: [:financial_institution_id], :message => "Please select another checking account."
  validate :ensure_one_bank_user_id_per_vendor,  if: lambda {vendor.present? && bank_user_id_changed?}
  has_many :api_errors
  after_commit :register_bankjoy_user, on: :create, if: lambda {bankjoy_user?}
  after_commit :insert_init_transfer_record, on: :create
  after_create :assign_user_to_vendor_user_key  
  after_update :change_savings_account_in_user_goals, if: lambda {default_savings_account_identifier_changed?}
  has_one :vendor_user_key

  def bankjoy_user?
    vendor.try(:bankjoy_vendor?).present?
  end

  def insert_init_transfer_record
    if self.api_errors.blank?
      Transfer.where(user: self, next_transfer_date: nil, amount: 0, end_date: 'infinity', status: :successful, origin_account: checking_account_identifier, destination_account: default_savings_account_identifier).first_or_create
    end
  end

  protected

  def change_savings_account_in_user_goals
    self.goals.where(savings_account_identifier: default_savings_account_identifier_was)
              .update_all(savings_account_identifier: default_savings_account_identifier)
  end

  def register_bankjoy_user
    resp = BankJoyService.register_user(checking_account_identifier)
    if resp["Status"] == 'Failure'
      self.api_errors << ApiError.new(status: resp["Status"], response: resp["Reason"], service: :aws_lambda, function: :registration)
    elsif resp["Status"] == 'Success'
      savings_acct_balance = Goal.where(savings_account_identifier: default_savings_account_identifier, user_id: id).first.try(:savings_acct_balance).to_f
      goal = Goal.new(tag: "Safety Net", xref_goal_name: "Other Goal", financial_institution: financial_institution, 
                      priority: 1,  target_amount: resp["Result"]["safety_net"].to_f)
      self.goals << goal
      login_bankjoy_user
      # Any previous errors associated with the registration should be removed if successful.
      self.api_errors.where(service: :aws_lambda, function: :registration).destroy_all
    end
  end

  def login_bankjoy_user
    resp = BankJoyService.user_login(id)
    if resp["Status"] == 'Failure'
      self.api_errors << ApiError.new(status: resp["Status"], response: resp["Reason"], service: :aws_lambda, function: :login)
    elsif resp["Status"] == 'Success'
      self.api_errors.where(service: :aws_lambda, function: :login).destroy_all
    end
  end

  def vendor_user_key_with_no_user
    if VendorUserKey.where(key: vendor_user_key).where("user_id is not null").present?
      errors.add(:vendor_user_key, 'user has already been assigned to key')
    elsif VendorUserKey.where(key: vendor_user_key, user_id: nil).empty?
      errors.add(:vendor_user_key, 'doesn\'t exist')
    end
  end

  def assign_user_to_vendor_user_key
    vendor_user_key_obj = VendorUserKey.find_by(key: vendor_user_key, user_id: nil)
    vendor_user_key_obj.update_attributes(user: self)
  end

  def ensure_one_bank_user_id_per_vendor
    if vendor.users.where.not(id: id).where(bank_user_id: bank_user_id).any?
      errors.add(:bank_user_id, 'already exists for another user within vendor.')
    end
  end

  def verify_max_transfer_amount_for_user_is_equal_or_less_than_financial_institution_amount
    financial_institution_max_transfer = self.financial_institution.max_transfer_amount
    if self.max_transfer_amount > financial_institution_max_transfer
      self.max_transfer_amount = financial_institution_max_transfer
    end
  end
end

