class OutcomesController < ApplicationController
  def index
    @events = Event.unresolved
  end

  def purchase
    @outcome = Outcome.find params[:id]
    current_user.purchase(@outcome, params[:quantity].to_i)
    redirect_to outcomes_path
  end

  def show
    @outcome = Outcome.find params[:id]
  end
end
