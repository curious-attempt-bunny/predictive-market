class StaticController < ApplicationController
  def home
    if current_user
      redirect_to outcomes_path
    else
      redirect_to about_path
    end
  end

  def about
    @events = Event.all
  end
end
