require 'rails_helper'

RSpec.describe Vendors::Dashboard::FinancialInstitutions::UsersController, type: :controller do
 let(:vendor_user_key) {FactoryGirl.create(:vendor_user_key)}
 let(:financial_institution) {FactoryGirl.create(:financial_institution, vendor: vendor_user_key.vendor)}
  describe "create" do
    it "user" do
      attributes = FactoryGirl.attributes_for(:user)
      expect {
        post :create, params: {vendor_user_key: vendor_user_key.key ,financial_institution_id: financial_institution.id, user: attributes}
      }.to change(User, :count).by(1)
    end
  end
end
