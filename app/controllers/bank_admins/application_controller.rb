class BankAdmins::ApplicationController < ApplicationController
  before_action :require_bank_admin_login
end

