module Graphable
  module ClassMethods
    
  end
  
  module InstanceMethods

    def lines
      [{
        :name => "actual temperature", 
        :data => self.temp_hash
      },
      {
        :name => "legal minimum", 
        :data => self.legal_hash
      },
      {
        :name => "outdoor temperature",
        :data => self.outdoor_temp_hash
      }]
    end
    
    def bars
      {"Avg Day" => avg_day_temp, "Avg Night" => avg_night_temp}
    end

    def low_temps
      [temps.min, outdoor_temps.min, 55].compact
    end

    def high_temps
      [temps.max, outdoor_temps.max, 68].compact
    end

    def range_min(margin = 5)
      low_temps.min - margin
    end

    def range_max(margin = 5)
      high_temps.max + margin
    end

    def reading_time_array
      readings.pluck(:created_at)
    end

    def table_array
      self.reverse_reading_nested_array.each_with_object([]) do |row_cells, arr|
        arr << build_row(row_cells)
      end
    end

    def build_row(row_cells)
      datetime, indoor_temp, outdoor_temp = *row_cells
      # datetime = adjust_for_time_zone(datetime)
      note = notes_text(datetime, indoor_temp, outdoor_temp)
      [pretty_time(datetime), pretty_date(datetime), indoor_temp, outdoor_temp, "", note]
    end

    def notes_text(datetime, indoor_temp, outdoor_temp)
      in_violation?(datetime, indoor_temp, outdoor_temp) ? 'violation' : ''
    end

    def temp_required_at(datetime)
      during_the_day?(datetime) ? day_time_legal_requirement : night_time_legal_requirement
    end
  end

  # def self.included(receiver)
  #   receiver.extend         ClassMethods
  #   receiver.send :include, InstanceMethods
  # end
end
