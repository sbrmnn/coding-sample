require 'rails_helper'

RSpec.describe MonottoUsers::UsersController, type: :controller do
  let(:monotto_user) {FactoryGirl.create(:monotto_user)}
  let(:financial_institution) {FactoryGirl.create(:financial_institution)}
  let(:user) {FactoryGirl.create(:user, financial_institution: financial_institution)}
  
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_monotto_user_token).and_return(monotto_user)
  end

  describe "index" do
    before do
      user
      get :index
    end

    it "gets a list of users" do
      expect(JSON.parse(response.body)).to eq(JSON.parse(User.all.to_json(include: [:demographics, :goals, :financial_institution, :messages])))
    end
  end

  describe "create" do
    before do
      @attributes = FactoryGirl.attributes_for(:user)
      @attributes[:financial_institution_id] = financial_institution.id
    end
    it "user" do
      expect {
         post :create, params: {user: @attributes}
      }.to change(User, :count).by(1)
    end
  end

  describe "show" do
    before do
      user
    end

    it "user" do
      get :show, params: {id: user.id}
      expect(JSON.parse(response.body)).to eq(JSON.parse(user.to_json(include: [:demographics, :goals, :financial_institution, :messages])))
    end
  end

  describe "update" do
    before do
      user
    end
    
    it "user sequence" do
      put :update, params: {id: user.id, user: {sequence: "ASFADFGDFGKDFGMBKFDFG"}}
      expect(JSON.parse(response.body)["sequence"]).to eq("ASFADFGDFGKDFGMBKFDFG")
    end
  end

  describe "destroy" do
    before do
      user
    end

    it "user" do
      expect{ 
        delete :destroy, params: {id: user.id}
      }.to change(User, :count).by(-1)
    end
  end
end
