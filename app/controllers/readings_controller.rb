class ReadingsController < ApplicationController
  protect_from_forgery except: :create

  def create
    render_error and return if verifier.failing?
    handle_dupe and return if verifier.dupe?
    render json: Reading.create_from_params(strong_params)
  end

  private

  def strong_params
    params.require(:reading).permit(:sensor_name, :temp, :time, :verification)
  end

  def handle_dupe
    render json: Reading.find_by_params(strong_params)
  end

  def verifier
    Verifier.new(strong_params)
  end

  def render_error
    status = verifier.status
    message = verifier.error_message
    render json: { code: status, error: message }, status: status
  end
end
