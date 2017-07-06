require 'rails_helper'

RSpec.describe FinancialInstitution, type: :model do
 let(:financial_institution) {FactoryGirl.create(:financial_institution, max_transfer_amount: 50)}
 let(:user) {FactoryGirl.create(:user, financial_institution: financial_institution, max_transfer_amount: 40)}
 describe "cascade_down_max_transfer_price_to_users" do
   context "when user max transfer amount is higher then the financial institution new max transfer amount" do
     it "cascades max transfer rate of the financial institution to the users" do
      financial_institution.update_attribute(:max_transfer_amount, 20)
      expect(user.max_transfer_amount).to eq(20)
     end
   end

   context "when user max transfer amount is less than the financial institution new max transfer amount" do
     it "cascades max transfer amount of the financial institution to the users" do
        financial_institution.update_attribute(:max_transfer_amount, 90)
        expect(user.max_transfer_amount).to eq(40)
     end
   end

   context "when user max transfer amount negative" do
     it "errors out" do
        financial_institution.max_transfer_amount = -1
        financial_institution.save
        expect(financial_institution.errors[:max_transfer_amount][0]).to eq('must be greater than or equal to 0')
     end
   end
  end
end
