class VendorKey < ApplicationRecord
  belongs_to :vendor 
  belongs_to :user, optional: true
  validates_uniqueness_of :user, allow_blank: true
  validates_uniqueness_of :key, allow_blank: false
end
