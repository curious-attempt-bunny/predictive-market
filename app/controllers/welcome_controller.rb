class WelcomeController < ApplicationController
  def index
    @outcomes = Outcome.all
    render
  end
end
