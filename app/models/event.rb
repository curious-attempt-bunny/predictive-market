class Event < ActiveRecord::Base

  has_many :outcomes

  accepts_nested_attributes_for :outcomes

  def outcome_terms(deltas = {})
    outcomes.collect do |outcome|
      outstanding = outcome.shares_outstanding
      outstanding += deltas[outcome] if deltas.include? outcome
      Math::E ** ( outstanding / Outcome::ARTIFICIAL_LIQUIDITY )
    end
  end
end
