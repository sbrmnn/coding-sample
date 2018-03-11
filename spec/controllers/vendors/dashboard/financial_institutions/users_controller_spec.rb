require 'rails_helper'

RSpec.describe Vendors::Dashboard::FinancialInstitutions::UsersController, type: :controller do
  describe "create" do
    it "user" do
      attributes = FactoryGirl.attributes_for(:financial_institution)
      attributes[:financial_institution_id] = financial_institution.id
      expect {
        post :create, params: {bank_admin: attributes}
      }.to change(BankAdmin, :count).by(1)
    end
  end
end
