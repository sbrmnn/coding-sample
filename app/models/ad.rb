class Ad < ApplicationRecord
   mount_uploader :image, AdImageUploaderUploader
end

