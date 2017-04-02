require 'rails_helper'

RSpec.describe BankAdmins::Users::TransfersController, type: :controller do
  let(:bank_admin) {FactoryGirl.create(:bank_admin)}
  let(:user) {FactoryGirl.create(:user, financial_institution: bank_admin.financial_institution)}
  let(:transfer) {FactoryGirl.create(:transfer, user: user)}

  before do
    transfer
    @id = transfer.id
    @user_id = transfer.user_id
    @origin_account = transfer.origin_account
    @destination_account = transfer.destination_account
    @amount = transfer.amount
    allow_any_instance_of(ApplicationController).to receive(:authenticate_bank_admin_token).and_return(bank_admin)
  end

  describe "index" do
    before do
      get :index, params: {user_bank_identifier: user.bank_identifier}
    end
    
    it "gets a list of transfers" do
      expect(JSON.parse(response.body)).to eq(JSON.parse([transfer].to_json)) 
    end
  end

  describe "show" do

    it "transfer" do
      get :show, params: {user_bank_identifier: user.bank_identifier, id: transfer.id}
      expect(JSON.parse(response.body)).to eq(JSON.parse(transfer.to_json))
    end
  end
end
