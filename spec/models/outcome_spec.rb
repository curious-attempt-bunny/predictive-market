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
      outcome1.share_price.should eq 0.5
    end
  end

  describe '#transaction_cost' do
    it 'returns the cost to purchase a given number of shares' do
      outcome1.transaction_cost(10).round(2).should eq 5.12
    end

    context 'after some transactions' do
      before do
        outcome1.shares_outstanding = 50
        outcome2.shares_outstanding = 10
        outcome1.save
        outcome2.save
        outcome1.reload
      end

      it 'still returns the correct cost' do
        outcome1.transaction_cost(-10).round(2).should eq -5.87
      end
    end
  end
end
