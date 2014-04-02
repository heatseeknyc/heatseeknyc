module Measurable
  module ClassMethods
    
  end
  
  module InstanceMethods
    def temps
      readings.pluck(:temp)
    end

    def avg_day_temp
      day_temps = self.get_day_temps
      return 0 if day_temps.empty?

      sum_of_temps = day_temps.sum 
      count_of_temps = day_temps.size

      avg_temp = sum_of_temps / count_of_temps
    end

    def avg_night_temp
      night_temps = self.get_night_temps
      return 0 if night_temps.empty?

      sum_of_temps = night_temps.sum 
      count_of_temps = night_temps.size
      
      avg_temp = sum_of_temps / count_of_temps
    end

    def get_day_temps
      day_temps = []
      self.reading_hash.each do |time, temp|
        hour = time.hour + time_offset_in_hours
        day_temps << temp if day_time_hours_include?(hour)
      end
      day_temps
    end

    def get_night_temps
      night_temps = []
      self.reading_hash.each do |time, temp|
        hour = time.hour + time_offset_in_hours
        night_temps << temp if night_time_hours_include?(hour)
      end
      night_temps
    end

    def lowest_day_time
      get_day_temps.min
    end
    
    def lowest_night_time
      get_night_temps.min
    end

    def highest_day_time
      get_day_temps.max
    end

    def highest_night_time
      get_night_temps.max
    end  
  end
  
  # def self.included(receiver)
  #   receiver.extend         ClassMethods
  #   receiver.send :include, InstanceMethods
  # end
end