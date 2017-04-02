class MonottoUser < ApplicationRecord
  include ModelAuthenticatable
  
  validates_presence_of :email
end
