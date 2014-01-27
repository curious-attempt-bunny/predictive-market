require 'spec_helper'

describe Event do
  let!(:event) { Event.create name: "How many licks does it take to get to the center of a tootsie pop?" }
  let!(:incorrect_outcome_1) { event.outcomes.create name: "1" }
  let!(:incorrect_outcome_2) { event.outcomes.create name: "2" }
  let!(:correct_outcome)     { event.outcomes.create name: "3" }

  describe '#resolve' do
    let(:calling_resolve) { event.resolve correct_outcome }
    let(:user) { User.create! email: 'test@test.com', password: '12345678' }

    before do
      user.purchase correct_outcome, 10
      user.purchase incorrect_outcome_1, 5
    end

    it 'marks the event as resolved' do
      expect { calling_resolve }.to change { event.reload.resolved? }.to(true)
    end

    it 'marks all outcomes as resolved' do
      expect { calling_resolve }.to change { event.outcomes.where( resolved: true ).count }.from(0).to(3)
    end

    it 'marks the appropriate outcome as correct' do
      expect { calling_resolve }.to change { correct_outcome.correct? }.to(true)
    end

    it 'does not mark other outcomes as correct' do
      expect { calling_resolve }.not_to change { incorrect_outcome_1.correct? or incorrect_outcome_2.correct? }
    end

    it 'cashes out shares of the correct outcome' do
      expect { calling_resolve }.to change { user.reload.balance.to_i }.by(1000)
    end

    it 'deletes all holdings of all outcomes' do
      expect { calling_resolve }.to change { event.reload.holdings.empty? }.to(true)
    end
  end
end
