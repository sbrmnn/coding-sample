class Product < ApplicationRecord
  attr_accessor :goal_name
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :financial_institution_id
  belongs_to :financial_institution
  has_many :offers, dependent: :destroy  do
   def with_status
     joins(:offer_summary).select("offers.*, offer_summaries.delivered, offer_summaries.click_through")
   end
  end
end
