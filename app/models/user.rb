class User < ApplicationRecord
  has_many :demographics, dependent: :destroy
  has_many :transfers, dependent: :destroy
  has_many :goals, dependent: :destroy
  validates_presence_of :sequence
end

