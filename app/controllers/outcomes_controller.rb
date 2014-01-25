class OutcomesController < ApplicationController
  def show
    @outcome = Outcome.find params[:id]
  end
end
