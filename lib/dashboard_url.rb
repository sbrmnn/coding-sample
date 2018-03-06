class DashboardUrl
  attr_reader :bank_user_id, :financial_institution_id, :accounts, :checking_accounts, :savings_accounts, :vendor
  
  def initialize(vendor_id, bank_user_id, financial_institution_name, accounts)
   validate_inputs(vendor_id, bank_user_id, financial_institution_name, accounts)
   @bank_user_id = bank_user_id
   @financial_institution_id = FinancialInstitution.where(name: financial_institution_name, vendor_id: vendor_id).first_or_create.id
   @vendor = Vendor.find(vendor_id)
   @accounts = accounts
  end

  def build
    query_arr = []
    query_arr << "financial_institution_id=#{@financial_institution_id}"
    @checking_accounts.map{|ca| query_arr << "checking[]=#{ca}"}
    @savings_accounts.map{ |sa| query_arr << "savings[]=#{sa}"}
    query_arr << "financial_institution_id=#{@financial_institution_id}"
    query_arr << "bank_user_id=#{@bank_user_id}"
    query_string = query_arr.join("&")
    return "https://#{vendor.name}.monotto.com/#{vendor_user_key}?#{query_string}"
  end

  private

  def vendor_user_key
    @vendor_user_key ||= User.where(bank_user_id: @bank_user_id).first.try(:vendor_user_key).try(:key)
    if @vendor_user_key.blank?
      @vendor_user_key = VendorUserKey.create(vendor_id: vendor.id).key
    end
  end

  def validate_inputs(vendor_id, bank_user_id, financial_institution_name, accounts)
  	errors = []
    errors << "Vendor doesn't exist" if vendor_id.blank?
  	errors << "Financial Institution name must be present in json" if financial_institution_name.blank?
    if accounts.is_a? Array
      @checking_accounts ||=  accounts.map{|l| l["AccountNumber"]  if l["AccountType"] == 'checking'}.compact rescue nil
      @savings_accounts  ||=  accounts.map{|l| l["AccountNumber"]  if l["AccountType"] == 'savings'}.compact  rescue nil
      errors << "Checking account information must be present in json." if @checking_accounts.blank?
      errors << "Savings account information must be present in json."  if @savings_accounts.blank?
    else
      errors << "Account information must be present in json."
    end
    errors << "Customer id must be present in json." if bank_user_id.blank?
    raise RuntimeError.new(errors) if errors.present?
  end
end