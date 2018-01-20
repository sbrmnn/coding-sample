class Vendor < ApplicationRecord
  include Loginable
  has_many :users, through: :financial_institutions
  has_many :financial_institutions
  before_save :create_key
  validates_presence_of :name, :location
  validates_uniqueness_of :email

  def bankjoy_vendor?
    self.name.try(:downcase) == 'bankjoy' || self.name.try(:downcase) == 'bank joy'
  end

  protected

  def create_key
    if self.key.blank?
      token_length = 50
      token = SecureRandom.urlsafe_base64(token_length)
      while Vendor.exists?(:key => token) # Making sure token hasn't been assigned for another vendor.
        token = SecureRandom.urlsafe_base64(token_length)
      end
      self.key = token
    end
  end
end
