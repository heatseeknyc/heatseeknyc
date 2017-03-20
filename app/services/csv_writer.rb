class CSVWriter

  attr_reader :user

  TIME_FORMAT = "%l:%M%p"
  DATE_FORMAT = "%m/%d/%Y"

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def generate_csv
    CSV.generate do |csv|
      csv << ["TIME","DATE","TEMP INSIDE","TEMP OUTSIDE","TEMP OF HOT WATER","NOTES"]
      self.user.readings.each do |reading|
        csv << [
            reading.created_at.strftime(TIME_FORMAT),
            reading.created_at.strftime(DATE_FORMAT),
            reading.temp,
            reading.outdoor_temp,
            nil,
            reading.violation ? "violation" : nil
        ]
      end
    end
  end

  def filename
    "#{user.last_name}.csv"
  end
end