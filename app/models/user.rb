class User < ActiveRecord::Base
  has_many :readings
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address
  validates_presence_of :email

  def chart_hash
    if readings.empty?
      {Time.now => 0}
    else
      chart_hash = readings.inject({}) do |log, reading| 
        log[reading.created_at] = reading.temp
        log
      end
    end
  end

  def temps
    self.readings.collect{|reading|reading.temp}
  end

  def temps_with_legal
    temps | [55,68]
  end

  def range_min
    self.temps_with_legal.min
  end

  def range_max
    self.temps_with_legal.max
  end

  def range(margin = 5)
    {min: self.range_min - margin, max: self.range_max + margin}
  end

  def legal_hash
    Hash.new.tap do |legal_hash|
      time_array.each do |time|
        if (6..22).include?((time.hour - 5) % 24)
        legal_hash[time] = 68
        else
        legal_hash[time] = 55
        end
      end
    end
  end

  def legal_hash_with_pivots
    add_pivot_points_to(legal_hash)
  end

  def add_pivot_points_to(legal_hash)
    first_day = legal_hash.keys.first.to_i
    last_day = legal_hash.keys.last.to_i
    
    i = first_day
    step = 24 * 60 * 60

    while i < last_day
      t = Time.at(i)
      legal_hash[Time.new(t.year, t.month, t.day, 6, 0, 0)] = 55
      legal_hash[Time.new(t.year, t.month, t.day, 6, 0, 1)] = 68
      legal_hash[Time.new(t.year, t.month, t.day, 22, 0, 0)] = 68
      legal_hash[Time.new(t.year, t.month, t.day, 22, 0, 1)] = 55
      i += step
    end

    return legal_hash
  end

  def lines
    [{
      :name => "actual temperature", 
      :data => self.chart_hash
    },
    {
      :name => "legal minimum", 
      :data => self.legal_hash
    }]
  end

  def temp_array
    self.readings.map(&:temp)
  end

  def time_array
    self.readings.map(&:created_at)
  end

  def reading_hash
    self.reading_nested_array.to_h
  end

  def reading_nested_array
    self.readings.map do |reading|
      [reading.created_at, reading.temp]
    end
  end

  def bars
    {"Avg Day" => avg_day_temp, "Avg Night" => avg_night_temp}
  end

  def avg_day_temp
    day_temps = []
    self.reading_hash.each do |time, temp|
      day_temps << temp if (6..22).include?((time.hour - 5) % 24)
    end
    day_temps.sum / day_temps.size
  end

  def avg_night_temp
    night_temps = []
    self.reading_hash.each do |time, temp|
      night_temps << temp if !(6..22).include?((time.hour - 5) % 24)
    end
    night_temps.sum / night_temps.size
  end
end
