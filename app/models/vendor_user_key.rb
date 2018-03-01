class VendorUserKey < ApplicationRecord
  belongs_to :vendor 
  belongs_to :user, optional: true
  validates_uniqueness_of :user, allow_blank: true
  validates_uniqueness_of :key, allow_blank: false
  before_create :generate_key

  private

  def generate_key
    self.key = random_string = SecureRandom.hex
  end
end
