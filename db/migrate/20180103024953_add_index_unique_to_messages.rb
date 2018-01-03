class AddIndexUniqueToMessages < ActiveRecord::Migration[5.0]
  def change
  	add_index(:messages, [:message_obj_id, :message_obj_type, :user_id], unique: true, name: 'unique_messages')
  end
end
