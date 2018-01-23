class CreateApiErrors < ActiveRecord::Migration[5.0]
  def change
    create_table :api_errors do |t|
      t.string :status
      t.string :response
      t.string :service
      t.string :method
      t.belongs_to :user
      t.timestamps
    end
  end
end
