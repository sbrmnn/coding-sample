class Ad < ApplicationRecord
   mount_uploader :image, AdImageUploader
   skip_callback :commit, :after, :remove_previously_stored_image
   has_many :offers, dependent: :destroy
   belongs_to :financial_institution
   validates_presence_of :header, :body, :link, :name
   validates_uniqueness_of :name, scope: :financial_institution_id
   validates_format_of :link, :with => /.\.\S/i
   before_save :save_only_hostname_of_link


   protected

   def save_only_hostname_of_link
     uri = URI.parse(self.link)
     self.link = uri.host if uri.host.present?
   end
end

