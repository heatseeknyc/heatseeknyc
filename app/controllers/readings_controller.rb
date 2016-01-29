class ReadingsController < ApplicationController
   protect_from_forgery except: :create

  def create
    reading = Reading.create_from_params(strong_params)

    if reading[:error]
      render json: reading.to_json, status: reading[:code]
    else
      render json: reading.to_json
    end
  end

  private

  def strong_params
    params.require(:reading).permit(:sensor_name, :temp, :time, :verification)
  end
end
