class User < ActiveRecord::Base
  class InsufficientBalanceError < StandardError; end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :holdings

  def purchase(outcome, quantity)
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
end
