class Event < ActiveRecord::Base

  has_many :outcomes

  accepts_nested_attributes_for :outcomes, reject_if: proc { |attr| attr['name'].blank? }

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
