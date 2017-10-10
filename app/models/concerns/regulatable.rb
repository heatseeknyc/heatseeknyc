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

    def legal_requirement_array
      [day_time_legal_requirement, night_time_legal_requirement]
    end

    def day_time_legal_requirement
      68
    end

    def old_night_time_legal_requirement
      55
    end

    def night_time_legal_requirement
      62
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

    def in_violation?(datetime, indoor_temp, outdoor_temp)
      if during_the_day?(datetime)
        day_time_temps_below_minimum?(indoor_temp, outdoor_temp)
      else
        night_time_violation?(datetime, indoor_temp, outdoor_temp)
      end
    end

    def night_time_violation?(datetime, indoor_temp, outdoor_temp)
      # Law change in effect Oct 1, 2017
      # http://metcouncilonhousing.org/help_and_answers/heat_and_hot_water
      law_change_date = DateTime.new(2017, 10, 1, 0, 0, 0, ActiveSupport::TimeZone['America/New_York'].formatted_offset)

      if DateTime.now > law_change_date
        indoor_temp < night_time_legal_requirement
      else
        indoor_temp < old_night_time_legal_requirement &&
          (outdoor_temp == nil || outdoor_temp < night_time_outdoor_legal_requirement)
      end
    end

    def violation_count
      readings.reduce(0) do |count, r|
        if in_violation?(r.created_at, r.temp, r.outdoor_temp)
          count + 1
        else
          count
        end
      end
    end
  end

  # def self.included(receiver)
  #   receiver.extend         ClassMethods
  #   receiver.send :include, InstanceMethods
  # end
end
