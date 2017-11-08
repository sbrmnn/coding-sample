require 'rails_helper'

RSpec.describe MonottoUsers::GoalsController, type: :controller do
  let(:monotto_user) {FactoryGirl.create(:monotto_user)}
  let(:user) {FactoryGirl.create(:user)}
  let(:goal) {FactoryGirl.create(:goal)}
  let(:xref_goal_type) {FactoryGirl.create(:xref_goal_type)}
  
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_monotto_user_token).and_return(monotto_user)
  end

  describe "index" do
    before do
      goal
      get :index
    end

    it "gets a list of goals" do
      expect(JSON.parse(response.body)).to eq(JSON.parse(Goal.all.to_json))
    end
  end

  describe "create" do
    before do
      xref_goal_type
      user
      @attributes = FactoryGirl.attributes_for(:goal)
      @attributes[:user_id] = user.id
      @xref_goal_type = FactoryGirl.create(:xref_goal_type)
    end
    it "goal" do
      expect {
         post :create, params: {goal: @attributes}
      }.to change(Goal, :count).by(1)
    end
  end

  describe "show" do
    before do
      goal
    end

    it "goal" do
      get :show, params: {id: goal.id}
      expect(JSON.parse(response.body)).to eq(JSON.parse(goal.to_json))
    end
  end

  describe "update" do
    before do
      goal
    end
    
    it "goal name" do
      put :update, params: {id: goal.id, goal: {tag: "Car"}}
      expect(JSON.parse(response.body)["tag"]).to eq("Car")
    end
  end

  describe "destroy" do
    before do
      goal
    end

    it "goal" do
      expect{ 
        delete :destroy, params: {id: goal.id}
      }.to change(Goal, :count).by(-1)
    end
  end
end
