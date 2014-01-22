class Event < ActiveRecord::Base
  has_many :outcomes
end
