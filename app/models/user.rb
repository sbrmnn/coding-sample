class User < ApplicationRecord
  has_many :demographics
  belongs_to :financial_institution
  validates_presence_of :sequence
  validates_presence_of :financial_institution_id
end

