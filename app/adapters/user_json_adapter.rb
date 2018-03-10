module UserJsonAdapter

  module Default
    def self.parse(json)
      accounts = json["Accounts"]
      checking_accounts = accounts_type_array(accounts, 'checking')
      savings_accounts  = accounts_type_array(accounts, 'savings')
      {
          bank_user_id: json["bank_user_id"],
          financial_institution_name: json["financial_institution_name"],
          checking_accounts: checking_accounts,
          savings_accounts: savings_accounts
      }
    end

    protected

    def self.accounts_type_array(accounts, type)
      begin
        accounts.map{|l| l["accounts"]  if l["type"] == type}.compact
      rescue NoMethodError
        nil
      end
    end
  end

  module BankJoy
    extend Default
    def self.parse(json)
      accounts = json["Accounts"]
      checking_accounts = accounts_type_array(accounts, 'checking')
      savings_accounts  = accounts_type_array(accounts, 'savings')
      {
          bank_user_id: json["CustomerId"],
          financial_institution_name: json["FinancialInstitutionId"],
          checking_accounts: checking_accounts,
          savings_accounts: savings_accounts
      }
    end
  end
end