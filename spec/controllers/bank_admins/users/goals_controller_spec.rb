require 'rails_helper'

RSpec.describe BankAdmins::Users::GoalsController, type: :controller do
  let(:bank_admin) {FactoryGirl.create(:bank_admin)}
  let(:user) {FactoryGirl.create(:user, financial_institution: bank_admin.financial_institution)}
  let(:goal) {FactoryGirl.create(:goal, user: user)}

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_bank_admin_token).and_return(bank_admin)
  end

  describe "index" do
    before do
      goal
      get :index, params: {user_bank_user_id: user.bank_user_id}
    end
    
    it "gets a list of goals" do
      expect(JSON.parse(response.body)).to eq(JSON.parse(user.goals.to_json(include:  [:xref_goal_type, :user, :goal_statistic]))) 
    end
  end
  describe "create" do
    it "goal" do
      expect {
         post :create, params: {user_bank_user_id: user.bank_user_id, goal: FactoryGirl.attributes_for(:goal)}
      }.to change(Goal, :count).by(1)
    end
  end
  describe "show" do
    before do
      goal
    end

    it "goal" do
      get :show, params: {user_bank_user_id: user.bank_user_id, id: goal.id}
      expect(JSON.parse(response.body)).to eq(JSON.parse(goal.to_json(include:  [:xref_goal_type, :user, :goal_statistic])))
    end
  end
  describe "update" do
    before do
      goal
      put :update, params: {user_bank_user_id: user.bank_user_id, id: goal.id, goal: {name: "Save for a Car", value: 10000}}
    end

    it "goal key" do
      expect(JSON.parse(response.body)["name"]).to eq("Save for a Car")
    end

     it "goal amount" do
      expect(JSON.parse(response.body)["amount"]).to eq(100000)
     end
  end
  describe "destroy" do
    before do
      goal
    end
    
    it "goal" do
      expect{ 
        delete :destroy, params: {user_bank_user_id: user.bank_user_id, id: goal.id}
      }.to change(Goal, :count).by(-1)
    end
  end
end
