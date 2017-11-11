class Message < ApplicationRecord
  belongs_to :message_obj, polymorphic: true
  belongs_to :user
end
