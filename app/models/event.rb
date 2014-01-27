class Event < ActiveRecord::Base

  has_many :outcomes
  has_many :holdings, through: :outcomes
  has_many :purchases, through: :outcomes

  scope :unresolved, -> { where.not(resolved: true) }

  accepts_nested_attributes_for :outcomes, reject_if: proc { |attr| attr['name'].blank? }

  def resolve(correct_outcome)
    raise "'#{correct_outcome.name}' is not a valid outcome for '#{name}'" unless outcomes.include? correct_outcome

    self.resolved = true
    outcomes.each { |outcome| outcome.resolve(outcome == correct_outcome) }

    save
  end

  def outcome_terms(deltas = {})
    outcomes.collect do |outcome|
      outstanding = outcome.shares_outstanding
      outstanding += deltas[outcome] if deltas.include? outcome
      Math::E ** ( outstanding / Outcome::ARTIFICIAL_LIQUIDITY )
    end
  end

  def plurality_outcome
    outcomes.max { |outcome| outcome.shares_outstanding }
  end
end
