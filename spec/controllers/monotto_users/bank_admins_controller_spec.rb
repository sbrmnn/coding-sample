require 'rails_helper'

RSpec.describe MonottoUsers::BankAdminsController, type: :controller do
  let(:monotto_user) {FactoryGirl.create(:monotto_user)}
  let(:financial_institution) {FactoryGirl.create(:financial_institution)}
  let(:bank_admin) {FactoryGirl.create(:bank_admin, financial_institution: financial_institution )}
  
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_monotto_user_token).and_return(monotto_user)
  end

  describe "index" do
    before do
      bank_admin
      get :index
    end

    it "gets a list of bank admins" do
      expect(JSON.parse(response.body)).to eq(JSON.parse(BankAdmin.all.to_json(include:  [:ads,:offers, :products, :users, :financial_institution])))
    end
  end

  describe "create" do
    it "bank admin" do
      attributes = FactoryGirl.attributes_for(:bank_admin)
      attributes[:financial_institution_id] = financial_institution.id
      expect {
         post :create, params: {bank_admin: attributes}
      }.to change(BankAdmin, :count).by(1)
    end
  end

  describe "show" do
    before do
      bank_admin
    end

    it "bank admin" do
      get :show, params: {id: bank_admin.id}
      expect(assigns(:bank_admin)).to eq (bank_admin)
    end
  end

  describe "update" do
    before do
      bank_admin
    end
    
    it "bank admin email" do
      put :update, params: {id: bank_admin.id, bank_admin: {email: 'example@monotto.com'}}
      expect(JSON.parse(response.body)["email"]).to eq('example@monotto.com')
    end
  end

  describe "destroy" do
    before do
      bank_admin
    end

    it "bank admin" do
      expect{ 
        delete :destroy, params: {id: bank_admin.id}
      }.to change(BankAdmin, :count).by(-1)
    end
  end
end
