class ChangeBodyToTextInAds < ActiveRecord::Migration[5.0]
  
  def up
    change_column :ads, :body, :text
  end

  def down
    change_column :ads, :body, :string
  end
end
