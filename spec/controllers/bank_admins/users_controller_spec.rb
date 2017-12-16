require 'rails_helper'

RSpec.describe BankAdmins::UsersController, type: :controller do
  let(:bank_admin) {FactoryGirl.create(:bank_admin)}
  let(:user) {FactoryGirl.create(:user, financial_institution: bank_admin.financial_institution)}
  
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_token).and_return(bank_admin)
  end

  describe "index" do
    before do
      user
      get :index
    end

    it "gets a list of users" do
      expect(assigns(:users)).to eq([user])
    end
  end

  describe "create" do
    it "user" do
      expect {
         post :create, params: {user: FactoryGirl.attributes_for(:user)}
      }.to change(User, :count).by(1)
    end
  end

  describe "show" do
    before do
      user
    end

    it "user" do
      get :show, params: {bank_user_id: user.bank_user_id}
      expect(assigns(:user)).to eq (user)
    end
  end

  describe "update" do
    before do
      user
    end

    context "greater than financial institution max transfer rate" do     
      it "updates max transfer rate" do
        put :update, params: {bank_user_id: user.bank_user_id, user: {max_transfer_amount: 5.00} }
        JSON.parse(response.body)["max_transfer_amount"].should == 5.0.to_s
      end

      it "updates max transfer rate (two signficant digits)" do
        put :update, params: {bank_user_id: user.bank_user_id, user: {max_transfer_amount: 5.01} }
        JSON.parse(response.body)["max_transfer_amount"].should == 5.01.to_s
      end
    end

    context "less or equal to than financial institution max transfer rate" do
      it "doesn't update max transfer rate" do
        put :update, params: {bank_user_id: user.bank_user_id, user: {max_transfer_amount: user.financial_institution.max_transfer_amount + 1} }
        JSON.parse(response.body)["max_transfer_amount"].should == user.financial_institution.max_transfer_amount.to_s
      end
    end
  end

  describe "destroy" do
    before do
      user
    end

    it "user" do
      expect{ 
        delete :destroy, params: {bank_user_id: user.bank_user_id}
      }.to change(User, :count).by(-1)
    end
  end
end
