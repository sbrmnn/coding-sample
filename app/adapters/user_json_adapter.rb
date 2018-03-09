module UserJsonAdapter
  module Default
    def self.parse(json)
      accounts = json["Accounts"] 
      begin
        checking_accounts = accounts.map{|l| l["accounts"]  if l["type"] == 'checking'}.compact
      rescue NoMethodError
        checking_accounts = nil
      end
      begin
        savings_acounts   = accounts.map{|l| l["accounts"]  if  l["type"] == 'savings'}.compact
      rescue NoMethodError
        savings_acounts = nil
      end
      {
          bank_user_id: json["bank_user_id"],
          financial_institution_name: json["financial_institution_name"],
          checking_accounts: checking_accounts,
          savings_accounts: savings_acounts
      }
    end
  end
  module Bankjoy
    def self.parse(json)
      accounts = json["Accounts"] 
      begin
        checking_accounts = accounts.map{|l| l["AccountNumber"]  if l["AccountType"] == 'checking'}.compact
      rescue NoMethodError
        checking_accounts = nil
      end
      begin
        savings_accounts = accounts.map{|l| l["AccountNumber"]  if l["AccountType"] == 'savings'}.compact
      rescue NoMethodError
        savings_accounts = nil
      end
      {
          bank_user_id: json["CustomerId"],
          financial_institution_name: json["FinancialInstitutionId"],
          checking_accounts: checking_accounts,
          savings_accounts: savings_accounts
      }
    end
  end
end