require "csv"

class ReadingsExporter
  HEADERS = [
    "timestamp",
    "temp_inside",
    "temp_outside",
    "in_violation",
    "sensor_id",
    "address",
    "zip_code"
  ].freeze

  def initialize(params = {})
    @filter = params[:filter]
    @start_time = params[:start_time]
    @end_time = params[:end_time]
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << HEADERS
      collection.each { |reading| csv << format_values(reading) }
    end
  end

  def collection
    readings = Reading
    readings = readings.where("readings.created_at >= ?", @start_time) if @start_time
    readings = readings.where("readings.created_at < ?", @end_time) if @end_time
    readings = readings.where(@filter) if @filter
    readings.includes(:user).order(:created_at)
  end

  private

  def format_values(reading)
    [].tap do |values|
      values.push(
        reading.created_at,
        reading.temp,
        reading.outdoor_temp,
        reading.violation,
        reading.sensor_id
      )

      if reading.user
        values.push(reading.user.address, reading.user.zip_code)
      else
        values.push(nil, nil)
      end
    end
  end
end