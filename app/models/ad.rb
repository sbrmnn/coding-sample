class Ad < ApplicationRecord
   mount_uploader :image, AdImageUploaderUploader
   validates_presence_of :header, :body, :link
end

