class ReadingsController < ApplicationController
   protect_from_forgery except: :create

  def create
    reading = Reading.create_from_params(strong_params)
    render json: reading
  end

  private
    def strong_params
      params.require(:reading).permit(:sensor_name, :temp, :time, :verification)
    end
end
