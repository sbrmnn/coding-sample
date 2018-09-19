class VendorUserBuilder
   attr_reader :vendor_id, :bank_user_id, :default_savings_account_identifier, :checking_account_identifier,
               :transfers_active, :max_transfer_amount, :financial_institution_name, :vendor_access_token

   def initialize(vendor_id, user_json)
     @vendor_id = vendor_id
     @bank_user_id = user_json[:bank_user_id]
     @default_savings_account_identifier = user_json[:default_savings_account_identifier]
     @checking_account_identifier = user_json[:checking_account_identifier]
     @transfers_active = user_json[:transfers_active]
     @max_transfer_amount = user_json[:max_transfer_amount]
     @financial_institution_name = user_json[:financial_institution_name]
     @vendor_access_token = user_json[:vendor_access_token]
   end

   def build
    self.set_default_savings_account_identifier
        .set_financial_institution
        .set_bank_user_id
        .set_checking_account_identifier
        .set_transfers_active
        .set_max_transfer_amount
        .set_vendor_user_key
        .set_vendor_access_token
   end

   protected

   def set_financial_institution
     user.financial_institution = financial_institution
     self
   end

   def set_bank_user_id
     user.bank_user_id = bank_user_id
     self
   end

   def set_vendor_access_token
     user.vendor_access_token = vendor_access_token
     self
   end
   
   def set_default_savings_account_identifier
     user.default_savings_account_identifier = default_savings_account_identifier
     self
   end

   def set_checking_account_identifier
     user.checking_account_identifier = checking_account_identifier
     self
   end

   def set_transfers_active
     return self if transfers_active.nil?
     user.transfers_active = transfers_active.to_b 
     self
   end

   def set_max_transfer_amount
     return self if max_transfer_amount.nil?
     user.max_transfer_amount = max_transfer_amount
     self
   end

   def financial_institution
     @financial_institution = FinancialInstitution.where(name: financial_institution_name, vendor_id: vendor_id).first_or_create
   end

   def user
     @user ||= User.new
   end

   def set_vendor_user_key
     user.vendor_user_key_val = VendorUserKey.where(vendor_id: vendor_id).create.key
     self
   end
end
