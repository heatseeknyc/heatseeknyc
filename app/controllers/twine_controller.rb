class TwineController < ApplicationController
  def index
    @user = User.find_by(first_name: "user1")
  end
end
