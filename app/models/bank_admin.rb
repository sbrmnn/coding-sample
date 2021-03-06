class BankAdmin < ApplicationRecord
  include Loginable
  has_many :users,                through: :financial_institution
  has_many :offers,               through: :financial_institution
  has_many :products,             through: :financial_institution
  has_many :ads,                  through: :financial_institution
  has_many :xref_goal_types,      through: :financial_institution 
  has_many :historical_snapshots, through: :financial_institution
  belongs_to :financial_institution
  validates_presence_of :financial_institution, :email, :name, :title, :phone
  validates_uniqueness_of :email
end
