class AddSequenceToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :sequence, :string
  end
end
