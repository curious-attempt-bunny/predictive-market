class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise: where to redirect after sign_in
  def after_sign_in_path_for(resource)
    outcomes_path
  end
end
