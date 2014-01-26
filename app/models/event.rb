class Event < ActiveRecord::Base

  has_many :outcomes

  def outcome_terms(deltas = {})
    outcomes.collect do |outcome|
      outstanding = outcome.shares_outstanding
      outstanding += deltas[outcome] if deltas.include? outcome
      Math::E ** ( outstanding / Outcome::ARTIFICIAL_LIQUIDITY )
    end
  end

  def majority_outcome
    outcomes.max { |outcome| outcome.shares_outstanding }
  end
end
