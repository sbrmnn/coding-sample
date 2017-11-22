namespace :account_snapshot do
  desc "Creates a historical record of account snapshot"
  task generate_historical_snapshot: :environment do
    SnapshotSummary.all.each do |ss|
      attributes = ss.attributes
      ss_keys = ss.attributes.keys
      hs_keys = HistoricalSnapshot.new.attributes.keys
      diff_key = ss_keys - hs_keys
      diff_key.each do |key_to_delete|
        attributes.delete(key_to_delete)
      end
      HistoricalSnapshot.new(attributes).save
    end
  end
end
