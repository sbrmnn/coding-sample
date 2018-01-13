class Message < ApplicationRecord
  belongs_to :message_obj, polymorphic: true
  belongs_to :user
  validates_uniqueness_of :message_obj_id, :scope => [:message_obj_type, :user_id]
end
