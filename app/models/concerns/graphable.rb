module Graphable
  module ClassMethods
    
  end
  
  module InstanceMethods

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
    
    def bars
      {"Avg Day" => avg_day_temp, "Avg Night" => avg_night_temp}
    end

    def chart_hash
      if readings.empty?
        return {Time.now => 0} 
      else
        reading_hash
      end
    end

    def legal_hash
      reading_time_array.each_with_object({}) do |time, legal_hash|
        hour = time.hour + time_offset_in_hours
        
        if day_time_hours_include?(hour)
          legal_hash[time] = day_time_legal_requirement
        else
          legal_hash[time] = night_time_legal_requirement
        end
      end
    end

    def temps_with_legal_requirement
      temps | legal_requirement_array
    end

    def legal_requirement_array
      [day_time_legal_requirement, night_time_legal_requirement]
    end

    def day_time_legal_requirement
      68
    end

    def night_time_legal_requirement
      55
    end

    def temps
      readings.pluck(:temp)
    end

    def range(margin = 5)
      {min: self.range_min - margin, max: self.range_max + margin}
    end

    def range_min
      self.temps_with_legal_requirement.min
    end

    def range_max
      self.temps_with_legal_requirement.max
    end

    def reading_time_array
      readings.pluck(:created_at)
    end

    def reading_hash
      # readings.pluck(:created_at, :temp).to_h // done with helper methods until tristan upgrades to ruby 2.1
      hashify(reading_nested_array)
    end

    def reading_nested_array
      readings.pluck(:created_at, :temp)
    end

    def hashify(nested_array)
      nested_array.each_with_object({}) { |pair, hsh| hsh[pair[0]] = pair[1] }
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

    def day_time_hours_include?(hour)
      day_time_hours.include?(hour % 24)
    end

    def night_time_hours_include?(hour)
      night_time_hours.include?(hour % 24)
    end

    def day_time_hours
      (6...22).to_a
    end

    def night_time_hours
      all_hours - day_time_hours
    end

    def all_hours
      (0...24).to_a
    end

    def time_offset_in_seconds
      TZInfo::Timezone.get('America/New_York').current_period.utc_total_offset
    end

    def time_offset_in_minutes
      time_offset_in_seconds / 60 
    end

    def time_offset_in_hours
      time_offset_in_minutes / 60
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