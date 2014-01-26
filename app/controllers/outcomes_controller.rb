class OutcomesController < ApplicationController
  def index
    @events = Event.all
    render
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
