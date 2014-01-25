require 'spec_helper'

describe User do
  describe "#purchase" do
    let(:balance) { 100 }
    let(:subject) { User.create!(balance: balance, email: 'foo@bar.com', password: '12345678') }
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

    describe "limited balance" do
      let(:balance) { 10 }

      it "should not go negative" do
        expect {
          subject.purchase(outcome, 10)
        }.to raise_error(User::InsufficientBalanceError)
      end
    end
  end
end
