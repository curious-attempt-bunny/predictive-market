require 'spec_helper'

describe Outcome do
  let!(:event) { Event.create name: "Sunrise tomorrow" }
  let!(:outcome1) { Outcome.create name: "The sun comes up.", event: event }
  let!(:outcome2) { Outcome.create name: "The sun does not come up.", event: event }

  context 'when first created' do
    describe '#shares_outstanding' do
      subject { outcome1.shares_outstanding }
      it { should eq 0 }
    end
  end

  describe '#share_price' do
    it 'returns the instantaneous price for a share of this outcome' do
      outcome1.share_price.should eq 50
    end
  end

  describe '#transaction_cost' do
    it 'returns the cost to purchase a given number of shares' do
      outcome1.transaction_cost(10).round(0).should eq 562
    end

    context 'after some transactions' do
      before do
        user = User.create!(email: 'foo@someplace.com', password: 'barbazqub')
        user.purchase(outcome1, 50)
        user.purchase(outcome2, 10)
      end

      it 'still returns the correct cost' do
        outcome1.transaction_cost(-10).round(0).should eq -851
      end
    end
  end
end
