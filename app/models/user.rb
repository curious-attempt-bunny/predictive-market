class User < ActiveRecord::Base
  class InsufficientBalanceError < StandardError; end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :holdings
  has_many :purchases

  def purchase(outcome, quantity)
    return if quantity == 0

    cost = outcome.transaction_cost(quantity)
    new_balance = balance - cost
    raise InsufficientBalanceError if new_balance < 0
    self.balance = new_balance
    save!

    purchases.create!(outcome: outcome, quantity: quantity, cost: cost)

    holding = holdings.where(outcome: outcome).first || holdings.build(outcome: outcome, quantity: 0)
    holding.quantity += quantity
    holding.save!
  end

  # Returns this user's Holding object for a given outcome.
  #
  def holdings_of(outcome)
    holdings.where(outcome: outcome).first || NullHolding.new(self, outcome)
  end

  def owns_shares_of?(outcome)
    holdings_of(outcome).quantity > 0
  end

  def net_worth
    balance + holdings.map { |holding| holding.valuation }.inject(0, :+)
  end
end
