class User < ActiveRecord::Base
  class InsufficientBalanceError < StandardError; end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :holdings

  def purchase(outcome, quantity)
    return if quantity == 0

    new_balance = balance - outcome.transaction_cost(quantity)
    raise InsufficientBalanceError if new_balance < 0
    self.balance = new_balance
    save!

    holding = holdings.where(outcome: outcome).first || holdings.build(outcome: outcome, quantity: 0)
    holding.quantity += quantity
    holding.save!
  end

  def net_worth
    balance + holdings.map { |holding| holding.valuation }.inject(:+)
  end
end
