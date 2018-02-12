class CalibrationsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @calibrations = Calibration.all.includes(:sensors)
  end

  private

  def authenticate_admin!
    if !signed_in?
      redirect_to welcome_index_path
    elsif !current_user.admin_or_more_powerful?
      redirect_to current_user
    end
  end
end
