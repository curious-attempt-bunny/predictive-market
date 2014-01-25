class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :holdings

  def purchase(outcome, quantity)
    # TODO deduct from the balance, etc.
    holdings.create!(outcome: outcome, quantity: quantity)
  end
end
