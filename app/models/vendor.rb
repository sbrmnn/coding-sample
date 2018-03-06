class Vendor < ApplicationRecord
  include Loginable
  has_many :users, through: :financial_institutions
  has_many :financial_institutions
  has_many :vendor_user_keys
  before_save :create_key
  before_save :downcase_vendor_name
  validates_presence_of :name, :location, :email
  validates_uniqueness_of :email


  def bankjoy_vendor?
    self.name.try(:downcase) == 'bankjoy'
  end


  protected

  def downcase_vendor_name
    self.name = self.name.downcase
  end

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
