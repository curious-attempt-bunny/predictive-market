class EventsController < ApplicationController

  def show
    @event = Event.find(params[:id])
  end

  def resolve
    event = Event.find params[:id]
    outcome = Outcome.find params[:outcome_id]

    event.resolve outcome
    redirect_to outcomes_url
  end

  def new
    @event = Event.new
  end

  def create
    params = params.require(:event).permit(:name, :description, outcomes_attributes: [:name])
    @event = Event.new(parama)

    respond_to do |format|
      if @event.save
        format.html { redirect_to outcomes_url, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

end
