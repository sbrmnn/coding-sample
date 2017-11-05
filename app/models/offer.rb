class Offer < ApplicationRecord
  attr_accessor :ad_name, :product_name

  validates_presence_of :product_name, if: lambda { self.product_id.blank? }
  validates_presence_of :ad_name, if: lambda { self.ad_id.blank? }

  validate :validate_ad
  validate :validate_product

  validates_presence_of :name, :value

  validates :symbol,
  :inclusion  => { :in => [ '=', '>', '<', '>=', '<=' ],
  :message    => "%{value} is not a valid symbol" }

  validates :condition,
  :inclusion  => { :in => [ 'balance' ],
  :message    => "%{value} is not a valid condition" }
  
  belongs_to :xref_goal_type
  belongs_to :financial_institution
  belongs_to :ad
  belongs_to :product

  has_many :messages, as: :message_obj

  protected 

  def validate_product
    if product_name
      prod_obj = self.financial_institution.products.where(name: product_name).first
      if prod_obj
        self.product_id = prod_obj.id
      else
        errors.add(:product_name, 'doesn\'t exist')
      end
    end
  end

  def validate_ad
    if ad_name 
      ad_obj = self.financial_institution.ads.where(name: ad_name).first
      if ad_obj
        self.ad_id = ad_obj.id
      else
        errors.add(:ad_name, 'doesn\'t exist')
      end
    end
  end
end
