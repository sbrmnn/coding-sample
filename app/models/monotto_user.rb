class MonottoUser < ApplicationRecord
  include Loginable
  validates_presence_of :email
end
