class StaticController < ApplicationController
  def home
    if current_user
      redirect_to outcomes_path
    end
    @events = Event.all
  end
end
