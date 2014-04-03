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
      hashify(reading_nested_array)
    end

    def reading_nested_array
      readings.pluck(:created_at, :temp, :outdoor_temp)
    end

    def reverse_reading_nested_array
      readings.order(created_at: :desc).pluck(:created_at, :temp, :outdoor_temp)
    end

    def table_array
      self.reverse_reading_nested_array.each_with_object([]) do |row_cells, arr|
        arr << build_row(row_cells)
      end
    end

    def build_row(row_cells)
      datetime, indoor_temp, outdoor_temp = *row_cells
      datetime = adjust_for_time_zone(datetime)
      note = notes_text(datetime, indoor_temp, outdoor_temp)
      [pretty_time(datetime), pretty_date(datetime), indoor_temp, outdoor_temp, "", note]
    end

    def notes_text(datetime, indoor_temp, outdoor_temp)
      in_violation?(datetime, indoor_temp, outdoor_temp) ? 'violation' : ''
    end

    def temp_required_at(datetime)
      during_the_day?(datetime) ? day_time_legal_requirement : night_time_legal_requirement
    end

    def hashify(nested_array)
      nested_array.each_with_object({}) { |pair, hsh| hsh[pair[0]] = pair[1] }
    end
  end

  # def self.included(receiver)
  #   receiver.extend         ClassMethods
  #   receiver.send :include, InstanceMethods
  # end
end