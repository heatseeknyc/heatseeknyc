# TODO: replace Regulatable module with Regulator class
class Regulator
  attr_reader :readings
  def initialize(readings)
    if readings.respond_to?(:each)
      @readings = readings
    else
      @readings = [readings]
    end
  end

  def has_detected_violation?
    readings.any? do |r|
      # TODO: make it unnecessary to instantiate another class for this
      User.new.in_violation?(r.created_at, r.temp, r.outdoor_temp)
    end
  end

  def inspect!
    user = User.new # get rid of this, the user class does not belong here
    readings.each do |r|
      r.violation = user.in_violation?(r.created_at, r.temp, r.outdoor_temp)
      r.save
    end
  end

  def batch_inspect!(batch_size:100, silent:false)
    number_of_batches = (readings.count / batch_size.to_f).ceil
    puts "#{readings.count} in #{number_of_batches} batches" unless silent
    (1..number_of_batches).each do |batch_number|
      place = batch_number * batch_size
      batch = readings.order(updated_at: :asc).first(place).last(batch_size)
      Regulator.new(batch).inspect!
      puts "finished #{batch_number} / #{number_of_batches}" unless silent
    end
  end
end
