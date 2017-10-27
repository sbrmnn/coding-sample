class Offer < ApplicationRecord
   attr_accessor :ad_header, :ad_body, :ad_link, :ad_image_url
   belongs_to :xref_goal_type
   belongs_to :financial_instiution
end
