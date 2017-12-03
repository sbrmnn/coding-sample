class Offer < ApplicationRecord
  attr_accessor :ad_name, :product_name, :xref_goal_name
  before_validation :downcase_columns
  validates_presence_of :product_name, if: lambda { self.product_id.blank? }
  validates_presence_of :ad_name, if: lambda { self.ad_id.blank? }
  validates_presence_of :xref_goal_name, if: lambda { self.xref_goal_type_id.blank? }
  validates :value, numericality: { less_than_or_equal_to: 100}, if: lambda { self.condition == 'percentage_complete' }
  has_one :offer_summary
  validate :validate_ad
  validate :validate_product
  validate :validate_xref_goal_name

  validates_presence_of :value

  validates :symbol,
  :inclusion  => { :in => [ '=', '>', '<', '>=', '<=' ],
  :message    => "%{value} is not a valid symbol" }

  validates :condition,
  :inclusion  => { :in => [ 'balance', 'percentage_complete', 'time_until_completion'],
  :message    => "%{value} is not a valid condition" }
  
  belongs_to :xref_goal_type
  belongs_to :financial_institution
  belongs_to :ad
  belongs_to :product

  has_many :messages, as: :message_obj


  protected 

  def downcase_columns
    self.condition = condition.try(:parameterize).try(:underscore)
  end
 
  def validate_xref_goal_name
    if xref_goal_name
      xref_goal_name_obj = self.financial_institution.xref_goal_types.where(name: xref_goal_name).first
      if xref_goal_name_obj
        self.xref_goal_type_id = xref_goal_name_obj.id
      else
        errors.add(:xref_goal_name, 'doesn\'t exist')
      end
    end
  end

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
