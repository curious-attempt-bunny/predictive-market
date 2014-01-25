class Outcome < ActiveRecord::Base

  # The higher this number, the higher the "inertia" of the initial share
  # price, and the more money the market might give away on a given event.
  #
  ARTIFICIAL_LIQUIDITY = 20.0

  belongs_to :event
  has_many :holdings

  before_create { |outcome| outcome.shares_outstanding = 0 }

  def share_price
   numerator = Math::E ** (shares_outstanding / ARTIFICIAL_LIQUIDITY)
   denominator = event.outcome_terms.inject(:+)

   # We're multiplying by 100 because we don't have cents in our currency
   100 * numerator / denominator
  end

  def transaction_cost(num_shares)
    cost_function( self => num_shares ) - cost_function
  end

  def shares_outstanding
    holdings.sum(:quantity)
  end

  def opposing
    event.outcomes.reject { |opposing| opposing == self }
  end

  private

  def cost_function(deltas = {})
    # We're multiplying by 100 because we don't have cents in our currency
    100 * ARTIFICIAL_LIQUIDITY * Math.log(event.outcome_terms(deltas).inject(:+))
  end

end
