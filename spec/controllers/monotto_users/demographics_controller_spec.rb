require 'rails_helper'

RSpec.describe MonottoUsers::DemographicsController, type: :controller do
  let(:monotto_user) {FactoryGirl.create(:monotto_user)}
  let(:user) {FactoryGirl.create(:user)}
  let(:demographic) {FactoryGirl.create(:demographic)}
  
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_monotto_user_token).and_return(monotto_user)
  end

  describe "index" do
    before do
      demographic
      get :index
    end

    it "gets a list of demographics" do
      expect(JSON.parse(response.body)).to eq([JSON.parse(demographic.to_json(include:  :user))])
    end
  end

  describe "create" do
    it "demographic" do
      attributes = FactoryGirl.attributes_for(:demographic)
      attributes[:user_id] = user.id
      expect {
         post :create, params: {demographic: attributes}
      }.to change(Demographic, :count).by(1)
    end
  end

  describe "show" do
    before do
      demographic
    end

    it "bank admin" do
      get :show, params: {id: demographic.id}
      expect(JSON.parse(response.body)).to eq(JSON.parse(demographic.to_json(include:  :user)))
    end
  end

  describe "update" do
    before do
      demographic
    end
    
    it "demographic key" do
      put :update, params: {id: demographic.id, demographic: {key: 'example@monotto.com'}}
      expect(JSON.parse(response.body)["key"]).to eq('example@monotto.com')
    end
  end

  describe "destroy" do
    before do
      demographic
    end

    it "demographic" do
      expect{ 
        delete :destroy, params: {id: demographic.id}
      }.to change(Demographic, :count).by(-1)
    end
  end
end
