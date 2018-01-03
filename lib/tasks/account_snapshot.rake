namespace :account_snapshot do
  desc "Creates a historical record of account snapshot"
  task generate_historical_snapshot: :environment do
    FinancialInstitution.all.each do |fi|
      SnapshotPresenter.new(fi).create_historical_record
    end
  end
end


