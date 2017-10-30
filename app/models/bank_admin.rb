class BankAdmin < ApplicationRecord
  include ModelAuthenticatable
  has_many :users,    through: :financial_institution
  has_many :offers,   through: :financial_institution
  has_many :products, through: :financial_institution
  has_many :ads,      through: :financial_institution
  has_many :messages, through: :financial_institution

  belongs_to :financial_institution


  validates_presence_of :financial_institution, :email, :name, :title, :phone
end
