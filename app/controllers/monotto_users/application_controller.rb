class MonottoUsers::ApplicationController < ApplicationController
  before_action :require_monotto_user_login
end
