class Demographic < ApplicationRecord
  validates_presence_of :key, :value, :user
  belongs_to :user
end
