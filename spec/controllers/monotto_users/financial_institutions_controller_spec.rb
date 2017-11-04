require 'rails_helper'

RSpec.describe MonottoUsers::FinancialInstitutionsController, type: :controller do
  let(:monotto_user) {FactoryGirl.create(:monotto_user)}
  let(:financial_institution) {FactoryGirl.create(:financial_institution)}
  
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_monotto_user_token).and_return(monotto_user)
  end

  describe "index" do
    before do
      financial_institution
      get :index
    end

    it "gets a list of financial institutions" do
      expect(JSON.parse(response.body)).to eq(JSON.parse(FinancialInstitution.all.to_json(include: [:ads, :bank_admins, :users, :offers, :products, :snapshot_summary])))
    end
  end

  describe "create" do
    it "financial institution" do
      attributes = FactoryGirl.attributes_for(:financial_institution)
      expect {
         post :create, params: {financial_institution: attributes}
      }.to change(FinancialInstitution, :count).by(1)
    end
  end

  describe "show" do
    before do
      financial_institution
    end

    it "financial institution" do
      get :show, params: {id: financial_institution.id}
      expect(JSON.parse(response.body)).to eq(JSON.parse(financial_institution.to_json(include: [:ads, :bank_admins, :users, :offers, :products, :snapshot_summary])))
    end
  end

  describe "update" do
    before do
      financial_institution
    end
    
    it "financial institution transfers_active" do
      put :update, params: {id: financial_institution.id, financial_institution: {transfers_active: true}}
      expect(JSON.parse(response.body)["transfers_active"]).to eq(true)
    end
  end

  describe "destroy" do
    before do
      financial_institution
    end

    it "financial institution" do
      expect{ 
        delete :destroy, params: {id: financial_institution.id}
      }.to change(FinancialInstitution, :count).by(-1)
    end
  end
end
