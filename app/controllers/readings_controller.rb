class ReadingsController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :site_authenticate
  before_action :check_if_accepting_readings

  def index
    if current_user && current_user.permissions <= User::PERMISSIONS[:team_member]
      respond_to do |format|
        format.csv do
          filter_params = params[:readings] || {}
          exporter = ReadingsExporter.new(filter_params)
          send_data(
            exporter.to_csv,
            type: "text/csv; charset=utf-8; header=present",
            filename: "sensor_readings.csv"
          )
        end
      end
    else
      render body: nil, status: :unauthorized
    end
  end

  def create
    render_error and return if verifier.failing?
    handle_dupe and return if verifier.dupe?
    render json: Reading.create_from_params(strong_params)
  end

  private

  def strong_params
    params.require(:reading).permit(:sensor_name, :temp, :time, :verification, :humidity)
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

  def check_if_accepting_readings
    if Rails.env.production? && ENV["READING_CREATION_ENDPOINT_ENABLED"].blank?
      render nothing: true, status: :service_unavailable
    end
  end
end
