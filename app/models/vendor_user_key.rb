class VendorUserKey < ApplicationRecord
  belongs_to :vendor 
  belongs_to :user, optional: true
  validates_uniqueness_of :user, allow_blank: true
  validates_uniqueness_of :key, allow_blank: false
  before_create :generate_key

  private

  def generate_key
  	token_length = 10
  	self.key = SecureRandom.urlsafe_base64(token_length).downcase
  	while VendorUserKey.exists?(:key => key) # Making sure key hasn't been assigned for another user.
      self.key = SecureRandom.urlsafe_base64(token_length).downcase
    end
  end
end
