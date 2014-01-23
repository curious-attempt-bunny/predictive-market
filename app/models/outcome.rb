class Outcome < ActiveRecord::Base

  # The higher this number, the higher the "inertia" of the initial share
  # price, and the more money the market might give away on a given event.
  #
  ARTIFICIAL_LIQUIDITY = 100.0

  belongs_to :event

  before_create { |outcome| outcome.shares_outstanding = 0 }

  def share_price
   numerator = Math::E ** (shares_outstanding / ARTIFICIAL_LIQUIDITY)
   denominator = event.outcome_terms.inject(:+)

   numerator / denominator
  end

  def transaction_cost(num_shares)
    cost_function( self => num_shares ) - cost_function
  end

  private

  def cost_function(deltas = {})
    ARTIFICIAL_LIQUIDITY * Math.log(event.outcome_terms(deltas).inject(:+))
  end

end
