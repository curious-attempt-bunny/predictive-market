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

  def net_worth
    balance + holdings.map { |holding| holding.valuation }.inject(:+)
  end
end
