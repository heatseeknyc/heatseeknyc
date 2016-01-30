class ReadingsController < ApplicationController
  protect_from_forgery except: :create

  def create
    render_error and return if invalid?
    render json: Reading.create_from_params(strong_params)
  end

  private

  def strong_params
    params.require(:reading).permit(:sensor_name, :temp, :time, :verification)
  end

  def invalid?
    verifier.failing?
  end

  def verifier
    Verifier.new(strong_params)
  end

  def render_error
    render json: { code: 400, error: verifier.error_message }, status: 400
  end
end
