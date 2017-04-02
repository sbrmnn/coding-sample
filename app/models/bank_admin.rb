class BankAdmin < ApplicationRecord
  include ModelAuthenticatable
  has_many :users, through: :financial_institution
  
  belongs_to :financial_institution

  validates_presence_of :financial_institution, :email, :name, :title, :phone
end
