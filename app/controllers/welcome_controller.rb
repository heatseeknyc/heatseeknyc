class WelcomeController < ApplicationController
  def index
    render "current_user_index" if current_user
  end
end
