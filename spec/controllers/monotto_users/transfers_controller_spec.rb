require 'rails_helper'

RSpec.describe MonottoUsers::TransfersController, type: :controller do
  let(:monotto_user) {FactoryGirl.create(:monotto_user)}
  let(:user) {FactoryGirl.create(:user)}
  let(:transfer) {FactoryGirl.create(:transfer)}
  
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_monotto_user_token).and_return(monotto_user)
  end

  describe "index" do
    before do
      transfer
      get :index
    end

    it "gets a list of transfers" do
      expect(JSON.parse(response.body)).to eq(JSON.parse([transfer].to_json))
    end
  end

  describe "create" do
    before do
      user
      @attributes = FactoryGirl.attributes_for(:transfer)
      @attributes[:user_id] = user.id
    end
    it "transfer" do
      expect {
         post :create, params: {transfer: @attributes}
      }.to change(Transfer, :count).by(1)
    end
  end

  describe "show" do
    before do
      transfer
    end

    it "transfer" do
      get :show, params: {id: transfer.id}
      expect(JSON.parse(response.body)).to eq(JSON.parse(transfer.to_json))
    end
  end

  describe "update" do
    before do
      transfer
    end
    it "transfer amount" do
      put :update, params: {id: transfer.id, transfer: {amount: 50}}
      expect(JSON.parse(response.body)["amount"]).to eq(50)
    end
  end

  describe "destroy" do
    before do
      transfer
    end

    it "transfer" do
      expect{ 
        delete :destroy, params: {id: transfer.id}
      }.to change(Transfer, :count).by(-1)
    end
  end
end
