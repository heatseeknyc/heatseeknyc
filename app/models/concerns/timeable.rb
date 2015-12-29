module Timeable
  module ClassMethods
    
  end
  
  module InstanceMethods
    def during_the_day?(datetime)
      day_time_hours_include?(datetime.hour)
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
      (0...24).to_a - day_time_hours
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

    def adjust_for_time_zone(datetime)
      datetime + time_offset_in_seconds
    end

    def pretty_time(datetime)
      datetime.strftime("%-l:%M %p")
    end

    def pretty_date(datetime)
      datetime.strftime("%b %-e, %Y")
    end  
  end
  
  # def self.included(receiver)
  #   receiver.extend         ClassMethods
  #   receiver.send :include, InstanceMethods
  # end
end
