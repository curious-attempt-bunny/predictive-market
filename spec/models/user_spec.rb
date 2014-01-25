require 'spec_helper'

describe User do
  describe "#purchase" do
    let(:subject) { User.create!(balance: 100, email: 'foo@bar.com', password: '12345678') }
    let(:outcome) { Outcome.create!(event_id: 1) }

    before do
      outcome.stub(:transaction_cost).and_return(20)
    end

    describe "a new holding" do
      it "should create a holding" do
        expect {
          subject.purchase(outcome, 10)
        }.to change {
          subject.holdings.size
        }.from(0).to(1)
      end

      it "should decrease the balance" do
        expect {
          subject.purchase(outcome, 10)
        }.to change {
          subject.balance
        }.from(100).to(80)
      end
    end

    describe "existing holding" do
      before do
        subject.purchase(outcome, 10)
      end

      it "should not create a new holding" do
        expect {
          subject.purchase(outcome, 10)
        }.to_not change {
          subject.holdings.size
        }
      end
    end

    pending "should not exceed budget" do

    end
  end
end
