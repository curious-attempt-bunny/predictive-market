class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :holdings

  def purchase(outcome, quantity)
    self.balance -= outcome.transaction_cost(quantity)
    save!
    holding = holdings.where(outcome: outcome).first || holdings.build(outcome: outcome, quantity: 0)
    holding.quantity += quantity
    holding.save!
  end
end
