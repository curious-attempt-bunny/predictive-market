class User < ActiveRecord::Base
  class InsufficientBalanceError < StandardError; end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :holdings

  def purchase(outcome, quantity, options = {})
    # Sell holdings in opposing outcomes first
    unless options[:balance_opposing_outcomes]
      opposing_quantity = outcome.opposing.map { |opposing| quantity(opposing) }.min
      if opposing_quantity && opposing_quantity > 0
        sell_quantity = [opposing_quantity, quantity].min
        outcome.opposing.each do |opposing|
          purchase(opposing, -sell_quantity, balance_opposing_outcomes: true)
        end
        quantity -= sell_quantity
      end
    end
    return if quantity == 0

    new_balance = balance - outcome.transaction_cost(quantity)
    raise InsufficientBalanceError if new_balance < 0
    self.balance = new_balance
    save!

    holding = holdings.where(outcome: outcome).first || holdings.build(outcome: outcome, quantity: 0)
    holding.quantity += quantity
    holding.save!
  end

  def quantity(outcome)
    holdings.where(outcome: outcome).sum(:quantity)
  end

  def valuation(outcome)
    return 0 if quantity(outcome) == 0
    -outcome.transaction_cost(-quantity(outcome))
  end

  def net_worth
    balance + holdings.map { |holding| valuation(holding.outcome) }.inject(:+)
  end
end
