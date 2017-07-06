require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  let(:financial_institution) {FactoryGirl.create(:financial_institution, max_transfer_amount: 50)}
  let(:user) {FactoryGirl.create(:user, financial_institution: financial_institution, max_transfer_amount: 40)}
  describe "verify_max_transfer_amount_for_user_is_equal_or_less_than_financial_institution_amount" do
    context "when user max transfer amount is higher then financial institution max transfer amount" do
      it "sets financial institution max transfer amount to user " do
       user.update_attribute(:max_transfer_amount, user.financial_institution.max_transfer_amount + 1)
       expect(user.max_transfer_amount).to eq(financial_institution.max_transfer_amount)
      end
    end

    context "when user max transfer amount is lower then financial institution max transfer amount" do
      it "sets max transfer rate that was specified to the user" do
       user.update_attribute(:max_transfer_amount, user.financial_institution.max_transfer_amount-1)
       expect(user.max_transfer_amount).to eq(financial_institution.max_transfer_amount-1)
      end
    end
    context "when user max transfer amount negative" do
     it "errors out" do
        user.max_transfer_amount = -1
        user.save
        expect(user.errors[:max_transfer_amount][0]).to eq('must be greater than or equal to 0')
     end
    end
  end
end
