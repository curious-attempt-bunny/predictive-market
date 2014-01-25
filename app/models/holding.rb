class Holding < ActiveRecord::Base
  belongs_to :user
  belongs_to :outcome
end