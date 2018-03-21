require 'rails_helper'

RSpec.describe Vendors::Dashboard::Users::Goals::RecurringTransferRulesController, type: :controller do
  let!(:vendor) {FactoryGirl.create(:vendor)}
  let!(:financial_institution) {FactoryGirl.create(:financial_institution, vendor: vendor)}
  let!(:vendor_user_key) {FactoryGirl.create(:vendor_user_key, vendor: vendor)}
  let!(:user) {FactoryGirl.create(:user, financial_institution: financial_institution, vendor_user_key_val: vendor_user_key.key)}
  let!(:goal) {FactoryGirl.create(:goal, user: user)}
  
  describe "update" do
    it "recurring transfer rule" do
      attributes = FactoryGirl.attributes_for(:recurring_transfer_rule)
      expect {
        put :update, params: {vendor_user_key: vendor_user_key.key, goal_id: goal.id, recurring_transfer_rules: attributes}
      }.to change(RecurringTransferRule, :count).by(1)
    end
  end
end
