class PDFWriter
  attr_reader :user, :table_array

  def initialize(user, years:)
    @user = user
    @years = years
    @table_array = user.table_array(readings)
  end

  def self.new_from_user_id(user_id, years:)
    new(User.find(user_id), years: years)
  end

  def filename
    user.last_name
  end

  def readings
    user.readings.where(
      "created_at >= ? AND created_at < ?",
      DateTime.new(@years[0], 10, 1),
      DateTime.new(@years[1], 10, 1)
    )
  end

  def readings_count
    @readings_count ||= readings.count
  end

  def violation_count
    @violation_count ||= readings.where(violation: true).count
  end

  def unit
    user.apartment ? ", Unit #{user.apartment}" : ""
  end
end
