class WelcomeController < ApplicationController
  def hello
    render :inline => "Welcome to the Prophetron!"
  end
end
