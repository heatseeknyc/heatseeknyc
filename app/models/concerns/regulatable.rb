module Regulatable
  module ClassMethods
    
  end
  
  module InstanceMethods
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

    def day_time_outdoor_legal_requirement
      55
    end

    def night_time_outdoor_legal_requirement
      40
    end

    def day_time_temps_below_minimum?(indoor_temp, outdoor_temp)
      indoor_temp < day_time_legal_requirement &&
      (outdoor_temp == nil || outdoor_temp < day_time_outdoor_legal_requirement)
    end

    def night_time_temps_below_minimum?(indoor_temp, outdoor_temp)
      indoor_temp < night_time_legal_requirement &&
      (outdoor_temp == nil || outdoor_temp < night_time_outdoor_legal_requirement)
    end

    def in_violation?(datetime, indoor_temp, outdoor_temp)
      if during_the_day?(datetime)
        day_time_temps_below_minimum?(indoor_temp, outdoor_temp)
      else
        night_time_temps_below_minimum?(indoor_temp, outdoor_temp)
      end
    end  
  end
  
  # def self.included(receiver)
  #   receiver.extend         ClassMethods
  #   receiver.send :include, InstanceMethods
  # end
end