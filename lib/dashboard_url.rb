class DashboardUrl
  attr_accessor :bank_user_id, :financial_institution_name, :checking_accounts, :savings_accounts, :vendor_id, :vendor_access_token
  
  def initialize
  end

  def get
    validate
    query_arr = []
    query_arr << "financial_institution_id=#{financial_institution_id}"
    query_arr << "vendor_access_token=#{vendor_access_token}" if vendor_access_token.present?
    checking_accounts.map{|ca| query_arr << "checking[]=#{ca}"}
    savings_accounts.map{ |sa| query_arr << "savings[]=#{sa}"}  
    query_arr << "bank_user_id=#{bank_user_id}"
    query_string = query_arr.join("&")
    "https://#{vendor.name}.monotto.com/#{vendor_user_key}?#{query_string}"
  end

  def vendor
    @vendor = Vendor.find_by(id: vendor_id)
  end

  def financial_institution_id
    @financial_institution_id = FinancialInstitution.where(name: financial_institution_name, vendor: vendor).first_or_create.id
  end

  def vendor_user_key
    @vendor_user_key = User.where(bank_user_id: bank_user_id).first.try(:vendor_user_key).try(:key)
    if @vendor_user_key.blank?
      @vendor_user_key = VendorUserKey.create(vendor: vendor).key
    end
    @vendor_user_key
  end

  private

  def validate
    errors = []
    errors << "Vendor id not provided." if vendor_id.blank?
    errors << "Vendor doesn't exist."   if vendor_id.present? && vendor.blank? 
    errors << "Checking accounts argument must be an array." unless checking_accounts.is_a? Array
    errors << "Savings accounts argument must be an array."  unless savings_accounts.is_a? Array
    errors << "Financial Institution name must be present in json" if  financial_institution_name.blank?
    errors << "Customer id must be present in json." if bank_user_id.blank?
    raise RuntimeError.new(errors) if errors.present?
  end
end