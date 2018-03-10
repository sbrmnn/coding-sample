class DashboardUrlBuilder
  attr_reader :dashboard_url, :vendor
  
  def initialize(vendor_id)
    get_vendor(vendor_id)
    @dashboard_url = DashboardUrl.new
  end

  def adapter=(adapter)
    if UserJsonAdapter.constants.include?(adapter.to_sym)
      @adapter = UserJsonAdapter.const_get(adapter.to_sym)
    else
      @adapter =  UserJsonAdapter.const_get(:Default)
    end
  end

  def adapter
    if @adapter.blank?
      self.adapter = vendor.name
    end
    @adapter
  end

  def consume_json(json)
    json_values = get_values_from_json(json)
    self.set_bank_user_id(json_values[:bank_user_id]).
         set_financial_institution_name(json_values[:financial_institution_name]).
         set_checking_accounts(json_values[:checking_accounts]).
         set_savings_accounts(json_values[:savings_accounts]).
         set_vendor(vendor.id).dashboard_url
  end

  def set_financial_institution_name(name)
    @dashboard_url.financial_institution_name = name
    self
  end

  def set_vendor(vendor_id)
    raise "Vendor doesn't exist" if vendor.blank?
    @dashboard_url.vendor_id = vendor.id
    self
  end

  def set_savings_accounts(accts=[])
    raise "argument must be an array" unless accts.is_a? Array
    @dashboard_url.savings_accounts = accts
    self
  end

  def set_checking_accounts(accts=[])
    raise "argument must be an array" unless accts.is_a? Array
    @dashboard_url.checking_accounts = accts
    self
  end

  def set_bank_user_id(bank_user_id)
    @dashboard_url.bank_user_id = bank_user_id
    self
  end

  protected

  def get_vendor(vendor_id)
    @vendor||= Vendor.find(vendor_id)
  end

  def get_values_from_json(json)
    self.adapter.parse(json)
  end
end