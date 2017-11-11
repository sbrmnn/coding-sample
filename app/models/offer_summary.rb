class OfferSummary < ApplicationRecord
  self.primary_key = "offer_id"
  belongs_to :offer
end
