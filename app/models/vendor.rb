class Vendor < ApplicationRecord
  include Loginable
  has_many :users, through: :financial_institutions
  has_many :financial_institutions
  has_many :vendor_user_keys
  validates_presence_of :name, :location, :email
  validates_uniqueness_of :email


  def bankjoy_vendor?
    self.name.try(:downcase) == 'bankjoy'
  end
end
