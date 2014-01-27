class Holding < ActiveRecord::Base
  belongs_to :user
  belongs_to :outcome

  validates_uniqueness_of :user_id, scope: :outcome_id

  def valuation
    -outcome.transaction_cost(-quantity)
  end
end

