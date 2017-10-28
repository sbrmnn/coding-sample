class Offer < ApplicationRecord
   attr_accessor :ad_header, :ad_body, :ad_link, :ad_image_url

   belongs_to :xref_goal_type

   belongs_to :financial_institution

   validates_presence_of :name, :condition, :value

   validates :symbol,
    :inclusion  => { :in => [ '=', '>', '<', '>=', '<=' ],
    :message    => "%{value} is not a valid symbol" }

   validates :amount, numericality: { greater_than_or_equal_to: 0}
end
