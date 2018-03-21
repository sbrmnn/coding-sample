require 'rails_helper'

RSpec.describe Vendors::Dashboard::Users::BalancesController, type: :controller do
  let!(:vendor) {FactoryGirl.create(:vendor)}
  let!(:financial_institution) {FactoryGirl.create(:financial_institution, vendor: vendor)}
  let!(:vendor_user_key) {FactoryGirl.create(:vendor_user_key, vendor: vendor)}
  let!(:user) {FactoryGirl.create(:user, financial_institution: financial_institution, vendor_user_key_val: vendor_user_key.key)}
  let!(:goal) {FactoryGirl.create(:goal, user: user, savings_acct_balance: 90)}
  
  describe "show" do
    it "balance" do
      get :show, params: {vendor_user_key: vendor_user_key.key }
      expect(JSON.parse(response.body)).to eq({"savings_balance"=>"90.0"})
    end
  end
end
