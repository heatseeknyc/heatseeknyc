class WelcomeController < ApplicationController
  def index
    redirect_to current_user if current_user
    # render "current_user_index" if current_user
  end
end
