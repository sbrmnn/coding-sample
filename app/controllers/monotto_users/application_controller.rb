class MonottoUsers::ApplicationController < ApplicationController
  before_filter :require_bank_admin_login
end
