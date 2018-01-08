class Vendor < ApplicationRecord
    include ModelAuthenticatable
    has_many :users, through: :financial_institutions
    has_many :financial_institutions
    before_save :create_public_key
    validates_presence_of :name, :location
    validates_uniqueness_of :email

    def bankjoy?
      self.name.try(:downcase) == 'bankjoy' || self.name.try(:downcase) == 'bank joy'
    end

    protected

    def create_public_key
      if self.public_key.blank?
        token_length = 25
        token = SecureRandom.urlsafe_base64(token_length)
        while Vendor.exists?(:public_key => token) # Making sure token hasn't been assigned for another vendor.
          token = SecureRandom.urlsafe_base64(token_length)
        end
        self.public_key = token
      end
    end
end
