class CreateOfferSummaries < ActiveRecord::Migration[5.0]
  def change
    create_view :offer_summaries
  end
end
