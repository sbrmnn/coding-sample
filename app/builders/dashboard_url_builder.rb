class DashboardUrlBuilder
  attr_reader :json_values, :vendor_id
  
  def initialize(vendor_id, user_json)
    @vendor_id = vendor_id
    self.adapter = vendor_name
    @json_values = consume_json(user_json)
  end

  def build
    self.set_bank_user_id
        .set_financial_institution_name
        .set_checking_accounts
        .set_savings_accounts
        .set_vendor
        .dashboard_url
  end

  protected

  def adapter=(adapter)
    capitalized_adapter = adapter.capitalize.to_sym
    if DashboardUrlJsonAdapter.constants.include?(capitalized_adapter)
      @adapter = DashboardUrlJsonAdapter.const_get(capitalized_adapter)
    else
      @adapter =  DashboardUrlJsonAdapter.const_get(:Default)
    end
  end

  def adapter
    if @adapter.blank?
      self.adapter = vendor.name
    end
    @adapter
  end

  def consume_json(json)
    get_values_from_json(json)
  end

  def dashboard_url 
    @dashboard_url ||= DashboardUrl.new
  end

  def set_financial_institution_name
    dashboard_url.financial_institution_name = json_values[:financial_institution_name]
    self
  end

  def set_vendor
    dashboard_url.vendor_id = vendor_id
    self
  end

  def set_savings_accounts
    raise "argument must be an array" unless json_values[:savings_accounts].is_a? Array
    dashboard_url.savings_accounts = json_values[:savings_accounts]
    self
  end

  def set_checking_accounts
    raise "argument must be an array" unless json_values[:checking_accounts].is_a? Array
    dashboard_url.checking_accounts = json_values[:checking_accounts]
    self
  end

  def set_bank_user_id
    dashboard_url.bank_user_id = json_values[:bank_user_id]
    self
  end

  def get_values_from_json(json)
    self.adapter.parse(json)
  end

  def vendor_name
    @vendor_name ||= Vendor.find(vendor_id).try(:name)
  end
end