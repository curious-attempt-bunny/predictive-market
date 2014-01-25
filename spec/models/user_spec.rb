require 'spec_helper'

describe User do
  describe "#purchase" do
    let(:balance)          { 100 }
    let(:subject)          { User.create!(balance: balance, email: 'foo@bar.com', password: '12345678') }
    let(:event)            { Event.create!(name: 'foobar') }
    let(:outcome)          { Outcome.create!(event: event, name:'positive') }
    let(:opposing_outcome) { Outcome.create!(event: event, name:'negative') }

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

    describe "buying with a holding in an opposing outcome" do
      before do
        subject.purchase(opposing_outcome, 20)
      end

      describe "when buying less than held in the opposing outcome" do
        it "should sell the opposing outcome" do
          expect {
            subject.purchase(outcome, 10)
          }.to change {
            subject.quantity(opposing_outcome)
          }.from(20).to(10)
        end

        it "should not buy the outcome" do
          expect {
            subject.purchase(outcome, 10)
          }.not_to change {
            subject.quantity(outcome)
          }
        end
      end

      describe "when buying more than held in the opposing outcome" do
        it "should sell the opposing outcome" do
          expect {
            subject.purchase(outcome, 30)
          }.to change {
            subject.quantity(opposing_outcome)
          }.from(20).to(0)
        end

        it "should buy the outcome" do
          expect {
            subject.purchase(outcome, 30)
          }.to change {
            subject.quantity(outcome)
          }.from(0).to(10)
        end
      end
    end
  end
end
