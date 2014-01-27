# This class is a Null Model representing the case of a given user not owning
# any shares of a given outcome.
#
class NullHolding
  attr_accessor :user, :outcome

  def initialize(user, outcome)
    @user = user
    @outcome = outcome
  end

  def quantity
    0
  end

  def valuation
    0
  end
end
