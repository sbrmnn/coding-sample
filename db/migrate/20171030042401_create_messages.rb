class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :message_obj_id
      t.string  :message_obj_type
      t.belongs_to :user
      t.integer :clicks, default: 0
      t.timestamps
    end
  end
end
