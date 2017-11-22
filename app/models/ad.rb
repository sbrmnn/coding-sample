class Ad < ApplicationRecord
   mount_uploader :image, AdImageUploader
   has_many :offers, dependent: :destroy
   belongs_to :financial_institution
   validates_presence_of :header, :body, :link, :name
   validates_uniqueness_of :name, scope: :financial_institution_id
end

