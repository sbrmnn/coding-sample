require 'rails_helper'

RSpec.describe Vendors::Dashboard::Users::GoalsController, type: :controller do
  let!(:vendor) {FactoryGirl.create(:vendor)}
  let!(:financial_institution) {FactoryGirl.create(:financial_institution, vendor: vendor)}
  let!(:vendor_user_key) {FactoryGirl.create(:vendor_user_key, vendor: vendor)}
  let!(:user) {FactoryGirl.create(:user, financial_institution: financial_institution, vendor_user_key_val: vendor_user_key.key)}
  let(:goal) {FactoryGirl.create(:goal, user: user, savings_acct_balance: 90)}

  describe "index" do
    before do
       goal
    end
    it "goals" do
      get :index, params: {vendor_user_key: vendor_user_key.key}
      expect(JSON.parse(response.body)).to eq(JSON.parse(Goal.where(id: goal.id).to_json(:include => [:xref_goal_type, :recurring_transfer_rule])))
    end
  end
  describe "create" do
    it "goals" do
      goals_attributes = FactoryGirl.attributes_for(:goal)
      expect {
        post :create, params: {vendor_user_key: vendor_user_key.key, goal: goals_attributes}
      }.to change(Goal, :count).by(1)
    end
  end
  describe "show" do
    before do
       goal
    end
    it "goals" do
      get :show, params: {id: goal.id, vendor_user_key: vendor_user_key.key}
      expect(JSON.parse(response.body)).to eq(JSON.parse(Goal.find(goal.id).to_json(:include => [:xref_goal_type, :recurring_transfer_rule])))
    end
  end
  describe "update" do
    before do
       goal
    end
    it "tag" do
      goals_attributes = {}
      goals_attributes[:tag] = "Very Big House"
      put :update, params: {id: goal.id, vendor_user_key: vendor_user_key.key, goal: goals_attributes}
      expect(JSON.parse(response.body)["tag"]).to eq("Very Big House")
    end
    it "target amount" do
      goals_attributes = {}
      goals_attributes[:target_amount] = 5000
      put :update, params: {id: goal.id, vendor_user_key: vendor_user_key.key, goal: goals_attributes}
      expect(JSON.parse(response.body)["target_amount"]).to eq(5000.to_f.to_s)
    end
  end
  describe "delete" do
    before do
       goal
    end
    it "goals" do
      expect {
        delete :destroy, params: {id: goal.id, vendor_user_key: vendor_user_key.key}
      }.to change(Goal, :count).by(-1)
    end
  end
end
