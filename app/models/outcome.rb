class Outcome < ActiveRecord::Base
  belongs_to :event

  def share_price
    5
  end
end
