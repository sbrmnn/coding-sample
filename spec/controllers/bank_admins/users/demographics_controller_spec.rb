require 'rails_helper'

RSpec.describe BankAdmins::Users::DemographicsController, type: :controller do
  let(:bank_admin) {FactoryGirl.create(:bank_admin)}
  let(:user) {FactoryGirl.create(:user, financial_institution: bank_admin.financial_institution)}
  let(:demographic) {FactoryGirl.create(:demographic, user: user)}

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_bank_admin_token).and_return(bank_admin)
  end

  describe "index" do
    before do
      demographic
      get :index, params: {user_bank_user_id: user.bank_user_id}
    end
    
    it "gets a list of demographics" do
      expect(JSON.parse(response.body)).to eq([JSON.parse(demographic.to_json)]) 
    end
  end
  describe "create" do
    it "creates demographic" do
      expect {
         post :create, params: {user_bank_user_id: user.bank_user_id, demographic: FactoryGirl.attributes_for(:demographic)}
      }.to change(Demographic, :count).by(1)
    end
  end
  describe "show" do
    before do
      demographic
    end

    it "shows demographic" do
      get :show, params: {user_bank_user_id: user.bank_user_id, id: demographic.id}
      expect(JSON.parse(response.body)).to eq(JSON.parse(demographic.to_json))
    end
  end
  describe "update" do
    before do
      demographic
      put :update, params: {user_bank_user_id: user.bank_user_id, id: demographic.id, demographic: {key: "Edited Key", value: "Edited Value"}}
    end

    it "updates demographic key" do
      expect(JSON.parse(response.body)["key"]).to eq("Edited Key")
    end

     it "updates demographic value" do
      expect(JSON.parse(response.body)["value"]).to eq("Edited Value")
     end
  end
  describe "destroy" do
    before do
      demographic
    end
    
    it "deletes demographic" do
      expect{ 
        delete :destroy, params: {user_bank_user_id: user.bank_user_id, id: demographic.id}
      }.to change(Demographic, :count).by(-1)
    end
  end
end
