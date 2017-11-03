class Product < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :financial_institution_id
  belongs_to :financial_institution
  has_many :offers
end
