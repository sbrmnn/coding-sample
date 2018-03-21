require 'rails_helper'

RSpec.describe Vendors::Dashboard::Users::Goals::TimeUntilCompletionsController, type: :controller do
  let!(:vendor) {FactoryGirl.create(:vendor)}
  let!(:financial_institution) {FactoryGirl.create(:financial_institution, vendor: vendor)}
  let!(:vendor_user_key) {FactoryGirl.create(:vendor_user_key, vendor: vendor)}
  let!(:user) {FactoryGirl.create(:user, financial_institution: financial_institution, vendor_user_key_val: vendor_user_key.key)}
  let!(:goal) {FactoryGirl.create(:goal, user: user, savings_acct_balance: 90)}
   
  describe "show" do
    it "time until completion" do
      get :show, params: {vendor_user_key: vendor_user_key.key, goal_id: goal.id } 
      expect(JSON.parse(response.body)).to eq({"time_until_completion"=>"unavailable"})
    end
  end
end
