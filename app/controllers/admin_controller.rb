class AdminController < ApplicationController
  before_action :validate_team_member!

  private

  def validate_team_member!
    redirect_to root_path unless user_signed_in? && current_user.team_member?
  end
end
